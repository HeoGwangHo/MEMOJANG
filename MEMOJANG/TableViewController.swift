//
//  TableViewController.swift
//  MEMOJANG
//
//  Created by macbook on 21/02/2020.
//  Copyright © 2020 Gwang-Ho Heo. All rights reserved.
//

import UIKit
import RealmSwift

/* Main 화면 */
class TableViewController: UITableViewController {
    var realm = try! Realm()
    var memoArray: Results<Memo>?

    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = .white
        self.tableView.rowHeight = 80.5 // 테이블뷰 셀 크기 고정
        setupRealm()
    }
    
    func setupRealm() {
        try! realm = Realm()
        
        func updateMemo() {
            if memoArray == nil {
                memoArray = self.realm.objects(Memo.self)
            }
            self.tvListView.reloadData()
        }
        updateMemo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tvListView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath) as! TableViewCellWithImage
        
        // 셀 커스텀 디자인
        cell.contentView.backgroundColor = .systemGreen
        cell.layer.cornerRadius = tableView.rowHeight / 2
        cell.contentView.layer.borderWidth = 6
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        
        
        cell.title?.text = memoArray?[indexPath.row].title // 제목
        cell.content?.text = memoArray?[indexPath.row].content // 내용
        
        guard let imageURL = URL(string: (memoArray?[indexPath.row].imageURL!)!) else { return cell }
        do {
            let imgData = try Data(contentsOf: imageURL)
            cell.img.image = UIImage(data: imgData) // 이미지
        } catch let err as NSError {
            print("이미지 로딩 오류 : \(err)")
        }
        return cell
    }

    /*// Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/

    // MARK: 테이블 뷰 셀 제거
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(memoArray![indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tvListView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*// Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }*/

    /*// Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }*/

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgImage" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            
            detailView.titletext = memoArray?[indexPath!.row].title
            detailView.contenttext = memoArray?[indexPath!.row].content
            detailView.id = memoArray?[indexPath!.row].id
            
            guard let imageURL = URL(string: (memoArray?[indexPath!.row].imageURL!)!) else { return }
            do {
                let imgData = try Data(contentsOf: imageURL)
                detailView.image = UIImage(data: imgData) // 이미지
            } catch let err as NSError {
                print("이미지 로딩 오류 : \(err)")
            }
            
        }
    }
}
