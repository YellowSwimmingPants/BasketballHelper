

import UIKit

class CreateGameTableViewController: UITableViewController {
    
    @IBOutlet weak var tfGameName: UITextField!
    var dateString: String?
    let players = ["王小平", "蔡小甫", "李小銓", "陳小志", "黃老師"]
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
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
