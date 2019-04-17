//
//  BillBoardTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import Foundation
import Starscream

class BillBoardTableViewController: UITableViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeDetailLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    var users: UserInfo!
    var user = [UserInfo]()
    let userDefault = UserDefaults()
    var billBoard: BillBoard!
    let url_server = URL(string: common_url_user + "BillBoardServlet")
    var socket: WebSocket!
    let url_server_ws = "ws://127.0.0.1:8080/myBasketballHelper_Web/BillBoardWebsocketServer/"
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.title = billBoard.title
        dateLabel.text = billBoard.dateStr
        typeLabel.text = billBoard.type
        if typeLabel.text == "公告" {
            typeDetailLabel.text = "📜"
        } else if typeLabel.text == "球賽" {
            typeDetailLabel.text = "🏀"
        } else if typeLabel.text == "請假" {
            typeDetailLabel.text = "🌡"
        } else {
            typeDetailLabel.text = ""
        }
        contentTextView.text = billBoard.content
    }
    
    override func viewDidLoad() {
        let userInfo = userDefault.data(forKey: "userDefault")
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
        let teamInfo = billBoard.teamInfo
        socket = WebSocket(url: URL(string: url_server_ws + teamInfo)!)
        socket.connect()
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
        requestParam["action"] = "deleteBillBoard"
        requestParam["billBoardId"] = "\(billBoard.billBoardId)"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([String : String].self, from: data!) {
                        DispatchQueue.main.async {
                            if result["success"] == "Yes" {
                                var newBillBoard = [String: String]()
                                newBillBoard["userAccount"] = self.users.userAccount
                                newBillBoard["message"] = "Yes"
                                if let jsonData = try? JSONEncoder().encode(newBillBoard) {
                                    let text = String(data: jsonData, encoding: .utf8)
                                    self.socket.write(string: text!)
                                }
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                showSimpleAlert(message: "刪除失敗", viewController: self)
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
