
import UIKit
import CoreLocation

class PlayerUpdate: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfPosition: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var label: UILabel!
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    var player: Page_playerList!
    var imageUpload: UIImage?
    
    
    override func viewDidLoad() {
        self.title = player.name
        showPlayer()

    }
    @IBAction func clickTakePicture(_ sender: Any) {
        imagePicker(type: .camera)
        
    }
    
    @IBAction func clickPickPicture(_ sender: Any) {
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
            imageUpload = playerImage
            imageView.image = playerImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickSave(_ sender: Any) {
        player.name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       player.nickname = tfNickName.text == nil ? "" : tfNickName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       player.phone = tfPhone.text == nil ? "" : tfPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        player.birthday = tfBirthday.text == nil ? "" : tfBirthday.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        player.number = tfNumber.text == nil ? "" : tfNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        player.position = tfPosition.text == nil ? "" : tfPosition.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        player.email = tfEmail.text == nil ? "" : tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var requestParam = [String: String]()
        requestParam["action"] = "playerUpdate"
        requestParam["player"] = try! String(data: JSONEncoder().encode(self.player), encoding: .utf8)
        if self.imageUpload != nil {
        requestParam["imageBase64"] = self.imageUpload!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
       }
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.label.text = "update fail"
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
    
    func showPlayer() {
        tfName.text = player.name
        tfNickName.text = player.nickname
        tfPhone.text = player.phone
        tfBirthday.text = player.birthday
        tfNumber.text = player.number
        tfPosition.text = player.position
        tfEmail.text = player.email
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = player.playerID
        // 圖片寬度 = 螢幕寬度的
        requestParam["imageSize"] = view.frame.width
        executeTask(url_server!, requestParam) { (data, response, error) in
            var image: UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }
            if image == nil {
                image = UIImage(named: "noImage.jpg")
            }
            DispatchQueue.main.async { self.imageView.image = image }
        }
        
    }
    
        
    
    

    
    
}
