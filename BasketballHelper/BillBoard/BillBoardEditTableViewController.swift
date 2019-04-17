//
//  BillBoardEditTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import Starscream

class BillBoardEditTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contextTextView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    var users: UserInfo!
    var user = [UserInfo]()
    let userDefault = UserDefaults()
    var viewController = UIViewController()
    var datePickerHidden = true
    let url_server = URL(string: common_url_user + "BillBoardServlet")
    var types = [String]()
    var socket: WebSocket!
    let url_server_ws = "ws://127.0.0.1:8080/myBasketballHelper_Web/BillBoardWebsocketServer/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            let teamInfo = users.teamInfo
            socket = WebSocket(url: URL(string: url_server_ws + teamInfo)!)
            socket.connect()
        }
        contextTextView.text = ""
        typeLabel.text = "🗓"
        types.append("公告")
        types.append("球賽")
        types.append("請假")
        datePickerChaged()
    }
    
    func datePickerChaged() {
        dateLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleDatepicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func toggleDatepicker() {
        datePickerHidden = !datePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func datePickerValue(_ sender: UIDatePicker) {
        datePickerChaged()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type = types[row]
        if type == "公告" {
            typeLabel.text = "📜"
        } else if type == "球賽" {
            typeLabel.text = "🏀"
        } else if type == "請假" {
            typeLabel.text = "🌡"
        } else {
            typeLabel.text = ""
        }
    }
    
    
    @IBAction func clickSave(_ sender: Any) {
        let date = datePicker.date
        let title = titleTextField.text == nil ? "" : titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = contextTextView.text == nil ? "" : contextTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var type = ""
        if typeLabel.text == "📜" {
            type = "公告"
        } else if typeLabel.text == "🏀" {
            type = "球賽"
        } else if typeLabel.text == "🌡" {
            type = "請假"
        }
        let encoder = JSONEncoder()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(format)
        if userDefault.data(forKey: "userDefault") != nil {
            let teamInfo = users.teamInfo
            let billBoard = BillBoard(0, date, title!, content!, type, teamInfo)
            var requestParam = [String: String]()
            requestParam["action"] = "insertBillBoard"
            requestParam["billBoard"] = try! String(data: encoder.encode(billBoard), encoding: .utf8)
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
                                    showSimpleAlert(message: "新增失敗", viewController: self)
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
           showToast(view: self.view, message: "請先註冊")
        }
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
}
