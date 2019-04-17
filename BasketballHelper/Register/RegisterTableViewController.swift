//
//  RegisterTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let url_server = URL(string: common_url_user + "UserServlet")
    let userDefault = UserDefaults()
    var viewController = UIViewController()
    var userInfos = [UserInfo]()
    var users: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let account = accountTextField.text == nil ? "" : accountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text == nil ? "" : passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = nameTextField.text == nil ? "" : nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text == nil ? "" : emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if account == "" {
            showToast(view: self.view, message: "請輸入帳號")
        } else if password == "" {
            showToast(view: self.view, message: "請輸入密碼")
        } else if name == "" {
            showToast(view: self.view, message: "請輸入暱稱")
        } else if email == "" {
            showToast(view: self.view, message: "請輸入信箱")
        } else {
            let user = UserInfo(0, account!, password!, name!, email!, 0 , "")
            var userInfo = [String: String]()
            userInfo["action"] = "insertUser"
            userInfo["user"] = String(data: try! JSONEncoder().encode(user), encoding: .utf8)
            executeTask(url_server!, userInfo) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let result = try! JSONDecoder().decode([String : String].self, from: data!)
                        DispatchQueue.main.async {
                            if result["success"] == "Yes" {
                                let newUser = result["userInfo"]
                                let login = try? JSONDecoder().decode(UserInfo.self, from: newUser!.data(using: .utf8)!)
                                let loginOK = try! JSONEncoder().encode(login)
                                self.userDefault.set(loginOK, forKey: "userDefault")
                                self.userDefault.synchronize()
                                self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "JoinTeam")
                                self.present(self.viewController, animated: true, completion: nil)
                            } else {
                                showSimpleAlert(message: "註冊失敗", viewController: self)
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
}
