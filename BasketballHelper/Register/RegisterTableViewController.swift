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
        }
        var userInfo = [String: String]()
        userInfo["action"] = "userInsert"
        userInfo["account"] = account
        userInfo["password"] = password
        userInfo["name"] = name
        userInfo["email"] = email
        executeTask(url_server!, userInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    let user = UserInfo(0, account!, password!, name!, email!, 0, "")
                    let result = try! JSONEncoder().encode(user)
                    let success = try? JSONDecoder().decode([String : String].self, from: data!)
                    DispatchQueue.main.async {
                        if success?["success"] == "Yes" {
                            self.userDefault.set(result, forKey: "userDefault")
                            self.userDefault.synchronize()
                            self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "JoinTeam")
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
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
}
