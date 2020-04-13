//
//  DetailViewController.swift
//  MEMOJANG
//
//  Created by Gwang_Ho on 19/03/2020.
//  Copyright © 2020 Gwang-Ho Heo. All rights reserved.
//
import UIKit
import RealmSwift

/* 작성 된 메모 보기 화면 */
class DetailViewController: UIViewController, UITextFieldDelegate {
    var id: String? // 선택한 메모의 id
    var titletext: String?// 선택한 메모의 제목
    var contenttext: String? // 선택한 메모의 내용
    var image: UIImage? // 선택한 메모의 이미지
    var imageURL: URL? = nil
    let picker = UIImagePickerController()
    
    
    @IBOutlet var addImage1: UIImageView! // 이미지 뷰
    @IBOutlet var tfTitle: UITextField! // 제목
    @IBOutlet var ContentTextView: UITextView! // 내용
    
    let date = Date()
    let dateFormatter = DateFormatter()
    
    // MAEK: 제목 글자수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
    
    override func viewDidLoad() {
        tfTitle.delegate = self
        picker.delegate = self
        tfTitle.returnKeyType = .done
        
        // MARK: 제목 밑줄 그어주기
        tfTitle.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x : 0, y: tfTitle.frame.size.height-1, width: tfTitle.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        tfTitle.layer.addSublayer((border))
        tfTitle.textAlignment = .center
        
        // MARK: 키보드에 ToolBar 추가
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // done 버튼 오른쪽으로 밀어내기 위해 사용
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        ContentTextView.inputAccessoryView = toolbar
        
        // 초기화면에서 선택한 셀의 내용을 보여줌
        tfTitle.text = titletext
        ContentTextView.text = contenttext
        addImage1.image = image
        
        /* 제목 공백 시 오늘 날짜 표시하기*/
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DefaultTitle = "∙ " + dateFormatter.string(from: date)
        self.tfTitle.placeholder = DefaultTitle
        
        // 키보드에 TextView가 가려지는 현상
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var r = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        r = self.ContentTextView.convert(r, from:nil)
        self.ContentTextView.contentInset.bottom = r.size.height
        self.ContentTextView.verticalScrollIndicatorInsets.bottom = r.size.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.ContentTextView.contentInset = contentInsets
        self.ContentTextView.verticalScrollIndicatorInsets = contentInsets
    }
    
    @objc func done() {
        self.view.endEditing(true)
    }
    // MARK: 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // 다른 곳 터치시 키보드 내리기
        self.tfTitle.resignFirstResponder()
        self.ContentTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEqual(self.tfTitle)) { // 제목입력 후 리턴키 눌럿다면
            self.ContentTextView.becomeFirstResponder() // 포커스 이동
        }
        return true
    }
    
    // MARK: 이미지 변경하기
    @IBAction func changeImage(_ sender: UIButton) {
        let changeImage = UIAlertController(title: "이미지 변경", message: "이미지를 변경 하시겠습니까?", preferredStyle: UIAlertController.Style.actionSheet)
        
        // 앨범
        let chAlbum = UIAlertAction(title: "앨범에서 가져오기", style: UIAlertAction.Style.default) {
            ACTION in self.openAlbum()
        }
        
        // 카메라
        let chCamera = UIAlertAction(title: "촬영 하기", style: UIAlertAction.Style.default) {
                ACTION in self.openCamera()
        }
        
        // 취소
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        changeImage.addAction(chAlbum)
        changeImage.addAction(chCamera)
        changeImage.addAction(cancel)
            
        present(changeImage, animated: true, completion: nil)
    
    }
    
    func openAlbum() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("카메라가 연결되지 않았습니다.")
        }
    }
    
    // MARK: 메모 수정하기
    @IBAction func updateMemo(_ sender: UIBarButtonItem) {
        let saveCheck = UIAlertController(title: "확인", message: "메모를 수정하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        let changMemo = UIAlertAction(title: "예", style: UIAlertAction.Style.default) {
            ACTION in self.change()
        }
        
        let cancel = UIAlertAction(title: "아니오", style: UIAlertAction.Style.cancel) {
            ACTION in self.navigationController?.popViewController(animated: true)
        }
        
        saveCheck.addAction(changMemo)
        saveCheck.addAction(cancel)
        
        present(saveCheck, animated: true, completion: nil)
    }
    
    func change() {
        var title = ""
        if tfTitle.text!.isEmpty { // 제목이 공백이라면 오늘 날짜를 저장
            title = "∙ " + dateFormatter.string(from: date)
        } else {
            title = tfTitle.text!
        }
        
        let urlString = imageURL?.absoluteString ?? ""
        let realm = try! Realm()
        try! realm.write{
            realm.create(Memo.self, value: ["id" : id, "title" : title, "content" : ContentTextView.text!, "imageURL" : urlString], update: .all)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImage1.image = image
        }
        
        imageURL = (info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")] as! URL)
        dismiss(animated: true, completion: nil)
    }
}
