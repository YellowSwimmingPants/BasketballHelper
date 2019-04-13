

import UIKit

class CreateGameTableViewController: UITableViewController, UINavigationControllerDelegate {
    var gameName: String?
    var gameDate: String?
    var startingLineup = NSMutableArray()

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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            if identifier == "segueDone" {
                if tfGameName.text != "" && startingLineup.count > 0 {
                    return true
                } else {
                    showToast(view: self.view, message: "請輸入比賽名稱並選擇至少一位場上球員")
                    return false
                }
            }
        return true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PeriodTableViewController{
            controller.gameName = tfGameName.text
            controller.gameDate = lbShowDate.text
            controller.startingLineup = startingLineup
        } else if let controller = segue.destination as? ChooseStartingLineupTableViewController{
                controller.startingLineup = self.startingLineup
                controller.delegate = self
        }
    }
    
}
