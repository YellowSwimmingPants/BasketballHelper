//
//  CreateGameViewController.swift
//  BasketballHelper
//
//  Created by 李宜銓 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var dateString: String?
    let players = ["王小平", "蔡小甫", "李小銓", "陳小志", "黃老師"]
    @IBOutlet weak var tfGameName: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return players.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return players[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func datePickerValueChanged(_ datePicker: UIDatePicker) {
        /* 準備格式化物件(中日期、短時間格式) */
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        /* date屬性可以取得/設定datePicker目前的日期 */
        dateString = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData() {
        let userDefaults = UserDefaults.standard
        let gameName = tfGameName.text ?? ""
        userDefaults.set(gameName, forKey: "gameName")
        userDefaults.set(dateString, forKey: "dateString")
        
        userDefaults.synchronize()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
