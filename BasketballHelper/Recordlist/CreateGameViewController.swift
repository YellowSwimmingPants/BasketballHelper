
import UIKit

class CreateGameViewController: UIViewController {

    @IBOutlet weak var tfGameName: UITextField!
    @IBOutlet weak var lbShowDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
//dfbdfbfdbdfb
    var gameName: String?
    var gameDate: String?
    var startingLineup = NSMutableArray()
    var dateString: String?
    var datePickerHidden = true
    let url_server = URL(string: common_url_user + "GameServlet")
    let tableView: UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
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
                makeToast(view: self.view, message: "請輸入比賽名稱並選擇至少一位場上球員")
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PeriodTableViewController{
            controller.gameName = tfGameName.text
            controller.gameDate = lbShowDate.text
            controller.startingLineup = startingLineup
        } else if let controller = segue.destination as? ChooseStartingLineupTableViewController{
            controller.startingLineup = self.startingLineup
        }
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
    func makeToast(view: UIView, message : String) {
        let toast_width = CGFloat(150)
        let toast_height = CGFloat(70)
        let toast_x = (view.frame.width - toast_width) / 2
        let toast_y = (view.frame.height - toast_height) / 2
        let toastLabel = UILabel(frame: CGRect(x: toast_x, y: toast_y, width: toast_width, height: toast_height))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    

    
}

extension CreateGameViewController {
    func hideKeyboard() {
        tfGameName.resignFirstResponder()
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

