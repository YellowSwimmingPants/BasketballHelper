//
//  UpdateGameTableViewController.swift
//  BasketballHelper
//
//  Created by 李宜銓 on 2019/4/1.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class UpdateGameTableViewController: UITableViewController {
    @IBOutlet weak var tfGameName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lbShowDate: UILabel!
    var datePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerChanged()
    }
    
    @IBAction func clickSave(_ sender: Any) {
        let gameName = tfGameName.text == nil ? "" : tfGameName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let gameDate = lbShowDate.text == nil ? "" : lbShowDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let game = Game(gameName, gameDate)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        datePickerChanged()
    }
    
    func datePickerChanged() {
        lbShowDate.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
    }
    
    func toggleDatePicker() {
        datePickerHidden = !datePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 3 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            toggleDatePicker()
        }
    }
}
