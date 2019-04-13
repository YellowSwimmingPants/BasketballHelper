
import UIKit
import CoreLocation

class InsertPlayer: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfPosition: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var label: UILabel!
    
    let userDefault = UserDefaults()
    var users: UserInfo!
    var userInfo: UserInfo!
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = userDefault.data(forKey: "userDefault")
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
        addKeyboardObserver()
    }
    @IBAction func clickTackPicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    @IBAction func imagePicker(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let playerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = playerImage
            imageView.image = playerImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
 
    @IBAction func clickSave(_ sender: Any) {
        let name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let nickname = tfNickName.text == nil ? "" : tfNickName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfPhone.text == nil ? "" : tfPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthday = tfBirthday.text == nil ? "" : tfBirthday.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let number = tfNumber.text == nil ? "" : tfNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let position = tfPosition.text == nil ? "" : tfPosition.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfEmail.text == nil ? "" : tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        
        let player = Page_playerList(0, name, nickname, phone, birthday, number, position, email, users.teamInfo)
        
        var requestParam = [String: String]()
        requestParam["action"] = "playerInsert"
        requestParam["player"] = try! String(data: JSONEncoder().encode(player), encoding: .utf8)
        // 有圖才上傳
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()//把image轉為base64字串
        }
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.label.text = "insert fail"
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
    
    @IBAction func didEndOnExit(_ sender: Any) { }
    
    
    
   
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight / 2.9
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
    



