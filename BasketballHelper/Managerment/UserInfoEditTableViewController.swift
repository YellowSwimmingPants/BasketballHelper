//
//  UserInfoEditTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class UserInfoEditTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    var image: UIImage?
    let url_server = URL(string: common_url_user + "UserServlet")
    let userDefault = UserDefaults()
    var userInfo = [UserInfo]()
    var users: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            userNameTextField.text = users.userName
            emailTextField.text = users.email
            showImage()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            imagePicker(type: .photoLibrary)
        }
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = userImage
            userImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSave(_ sender: Any) {
        let userName = userNameTextField.text == nil ? "" : userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text == nil ? "" : emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userPassword = passwordTextView.text == nil ? "" : passwordTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userInfo = userDefault.data(forKey: "userDefault")
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
        let user = UserInfo(0, users.userAccount, userPassword, userName, email, users.priority, users.teamInfo)
        var requestParam = [String: String]()
        requestParam["action"] = "userUpdate"
        requestParam["user"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([String : String].self, from: data!) {
                        DispatchQueue.main.async {
                            if result["success"] == "Yes" {
                                let userLogin = result["userInfo"]
                                let login = try? JSONDecoder().decode(UserInfo.self, from: userLogin!.data(using: .utf8)!)
                                let loginOK = try! JSONEncoder().encode(login)
                                self.userDefault.set(loginOK, forKey: "userDefault")
                                self.userDefault.synchronize()
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                showSimpleAlert(message: "修改失敗", viewController: self)
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func showImage() {
        var requestParam = [String: Any]()
        let userAccount = users.userAccount
        requestParam["action"] = "getImage"
        requestParam["userAccount"] = userAccount
        requestParam["imageSize"] = userImageView.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
}
