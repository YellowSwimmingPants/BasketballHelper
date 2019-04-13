import UIKit

class UpdateGameTableViewController: UITableViewController {
    @IBOutlet weak var tfGameName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lbShowDate: UILabel!
    var datePickerHidden = true
    var game: Game!
    let url_server = URL(string: common_url_playerInfo + "GameServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        self.title = game.gameName
        datePickerChanged()
        showGameInfo()
    }
    
    @IBAction func clickSave(_ sender: Any) {
        game.gameName = tfGameName.text == nil ? "" : tfGameName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        game.gameDate = lbShowDate.text == nil ? "" : lbShowDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //TODO:
        var requestParam = [String: String]()
        requestParam["action"] = "gameUpdate"
        requestParam["game"] = try! String(data: JSONEncoder().encode(self.game), encoding: .utf8)
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
                                } else {
                                    showToast(view: self.view, message: "update fail")
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
    
    func showGameInfo() {
        tfGameName.text = game.gameName
        lbShowDate.text = game.gameDate
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

    @IBAction func didEndOnExit(_ sender: Any) {
    }

}

extension UpdateGameTableViewController {
    func hideKeyboard() {
        tfGameName.resignFirstResponder()
        lbShowDate.resignFirstResponder()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight / 2
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
