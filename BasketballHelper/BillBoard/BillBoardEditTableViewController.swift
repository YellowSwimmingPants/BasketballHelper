//
//  BillBoardEditTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class BillBoardEditTableViewController: UITableViewController {
    

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contextTextView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    var datePickerHidden = true
    let url_server = URL(string: common_url + "BillBoardServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    @IBAction func clickSave(_ sender: Any) {
        let date = datePicker.date
        let title = titleTextField.text == nil ? "" : titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = contextTextView.text == nil ? "" : contextTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let type = ""
        let billBoard = BillBoard(0, date, title!, content!, type)
        var requestParam = [String: String]()
        requestParam["action"] = "billBoardInsert"
        requestParam["billBoard"] = try! String(data: JSONEncoder().encode(billBoard), encoding: .utf8)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    showSimpleAlert(message: "新增失敗", viewController: self)
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
    
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
