//
//  EditViewController.swift
//  MEMOJANG
//
//  Created by macbook on 21/02/2020.
//  Copyright © 2020 Gwang-Ho Heo. All rights reserved.
//

import UIKit
import RealmSwift

/* 작성하기 화면 */
class EditViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleTextField: UITextField! // 제목
    @IBOutlet var ContentTextView: UITextView! // 내용
    @IBOutlet var addImage1: UIImageView! // 첨부 이미지 1
    
    var imageURL:URL? = nil
    let date = Date()
    let dateFormatter = DateFormatter()
    let picker = UIImagePickerController()
    
    // MARK: Title 글자수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
    
    override func viewDidLoad() {
        titleTextField.delegate = self
        picker.delegate = self
        titleTextField.returnKeyType = .done // 제목 키보드 리턴타입 변경
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { // 화면 전환하고 0.5초 후 실행
            self.titleTextField.becomeFirstResponder() // 뷰 로드 후 텍스트 필드에 포커스
        }
        
        // MARK: 키보드에 ToolBar 추가
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // done 버튼 밀어내기 위해 사용
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        ContentTextView.inputAccessoryView = toolbar

        /* TextField 밑줄만 보여주기*/
        titleTextField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: titleTextField.frame.size.height-1, width: titleTextField.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        titleTextField.layer.addSublayer((border))
        titleTextField.textAlignment = .center
        
        /* 기본제목 오늘 날짜 표시하기*/
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DefaultTitle = "∙ " + dateFormatter.string(from: date)
        self.titleTextField.placeholder = DefaultTitle

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
        self.titleTextField.resignFirstResponder()
        self.ContentTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEqual(self.titleTextField)) { // 제목입력 후 리턴키 눌럿다면
            self.ContentTextView.becomeFirstResponder() // 포커스 이동
        }
        return true
    }
    
    // MARK: 이미지 첨부하기
    @IBAction func ImageLoad(_ sender: UIButton) {
        let imageLoading = UIAlertController(title: "이미지 첨부", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        // 앨범
        let addAlbum = UIAlertAction(title: "앨범에서 가져오기", style: UIAlertAction.Style.default) {
            ACTION in self.openAlbum()
        }
        // 촬영하기
        let addCamera = UIAlertAction(title: "촬영 하기", style: UIAlertAction.Style.default) {
            ACTION in self.openCamera()
        }
        // URL로 가져오기 (보류)
//        let addUrl = UIAlertAction(title: "URL 불러오기", style: UIAlertAction.Style.default) {
//            ACTION in
//        }
        // 취소
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        imageLoading.addAction(addAlbum)
        imageLoading.addAction(addCamera)
        imageLoading.addAction(cancel)
        
        present(imageLoading, animated: true, completion: nil)
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
    
    // MARK: MEMO 저장하기
    @IBAction func saveMemo(_ sender: UIBarButtonItem) {
        var title = ""
        if titleTextField.text!.isEmpty { // 제목이 공백이라면 오늘 날짜를 저장
            title = "∙ " + dateFormatter.string(from: date)
        } else {
            title = titleTextField.text!
        }
        let urlString = imageURL?.absoluteString ?? ""
        
        let savememo = Memo(value:["title" : title, "content" : ContentTextView?.text ?? "", "imageURL" : urlString])
        let realm = try! Realm()
        try! realm.write {
            realm.add(savememo)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImage1.image = image
        }
        
        imageURL = (info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerImageURL")] as! URL)
        dismiss(animated: true, completion: nil)
    }
}
