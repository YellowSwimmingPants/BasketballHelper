//
//  UserInfoEditTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class UserInfoEditTableViewController: UITableViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    var userInfo: UserInfo!
    var image: UIImage?
    let url_server = URL(string: common_url + "UserInfoServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func clickSave(_ sender: Any) {
        let userName = userNameTextField.text == nil ? "" : userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text == nil ? "" : emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userPassword = passwordTextView.text == nil ? "" : passwordTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let user = UserInfo(0, userInfo.userAccount, userPassword, userName, email, userInfo.priority)
        var requestParam = [String: String]()
        requestParam["action"] = "update"
        requestParam["userInfo"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
                                } else {
                                    showSimpleAlert(message: "修改失敗", viewController: self)
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
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
}
