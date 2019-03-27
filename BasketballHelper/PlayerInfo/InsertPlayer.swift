
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
    
    let url_server = URL(string: common_url + "PlayerServlet")
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let player = Page_playerList(0, name, nickname, phone, birthday, number, position, email )
        
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
}
    



