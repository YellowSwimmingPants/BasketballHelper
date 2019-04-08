

import UIKit

class CreateGameTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tfGameName: UITextField!
    var dateString: String?
//    let players = ["王小平", "蔡小甫", "李小銓", "陳小志", "黃老師"]
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePickerHidden = true
    @IBOutlet weak var lbShowDate: UILabel!
    
    let url_server = URL(string: common_url_user + "GameServlet")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerChanged()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        datePickerChanged()
    }
    
    func datePickerChanged() {
        lbShowDate.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let gameName = tfGameName.text == nil ? "" : tfGameName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let gameDate = lbShowDate.text == nil ? "" : lbShowDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let game = Game(0, gameName, gameDate)
        var requestParam = [String: String]()
        requestParam["action"] = "gameInsert"
        requestParam["game"] = try! String(data: JSONEncoder().encode(game), encoding: .utf8)
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
                                } else {
                                    showSimpleAlert(message: "insert failed", viewController: self)
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
