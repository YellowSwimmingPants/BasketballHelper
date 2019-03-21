//
//  BillBoardTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import Foundation

class BillBoardTableViewController: UITableViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    var billBoard: BillBoard!
    let url_server = URL(string: common_url + "BillBoardServlet")
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = billBoard.title
        dateLabel.text = DateFormatter().string(for: billBoard.date)
        typeLabel.text = billBoard.type
        contentTextView.text = billBoard.content
    }
    
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickDelete(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "是否確定刪除", preferredStyle: .alert)
        let commit = UIAlertAction(title: "OK", style: .destructive) { (delete) in
            self.deleteBillBoard()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(commit)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteBillBoard() {
        var requestParam = [String: String]()
        requestParam["action"] = "delete"
        requestParam["billBoardId"] = "\(billBoard.id)"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                   self.dismiss(animated: true, completion: nil)
                                } else {
                                    showSimpleAlert(message: "刪除失敗", viewController: self)
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}
