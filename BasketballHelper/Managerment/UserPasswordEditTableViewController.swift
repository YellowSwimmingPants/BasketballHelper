//
//  UserPasswordEditTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class UserPasswordEditTableViewController: UITableViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    let url_server = URL(string: common_url_user + "UserServlet")
    let userDefault = UserDefaults()
    var userInfo = [UserInfo]()
    var users: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
        }
    }
    
    @IBAction func clickSave(_ sender: Any) {
        if userDefault.data(forKey: "userDefault") != nil {
            let password = passwordTextField.text == nil ? "" : passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = newPasswordTextField.text == nil ? "" : newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirm = confirmTextField.text == nil ? "" : confirmTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if password == "" {
                showToast(view: self.view, message: "請輸入密碼" )
            } else if newPassword == "" {
                showToast(view: self.view, message: "請輸入新密碼" )
            } else if newPassword != confirm {
                showToast(view: self.view, message: "請確認密碼是否正確" )
            }
            let user = UserInfo(users.userId, users.userAccount, newPassword, users.userName, users.email, users.priority, users.teamInfo)
            let userAccount = user.userAccount
            var requestParam = [String: String]()
            requestParam["action"] = "findById"
            requestParam["userAccount"] = userAccount
            requestParam["userPassword"] = password
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = try? JSONDecoder().decode([String : String].self, from: data!) {
                            if result["success"] == "Yes" {
                                DispatchQueue.main.async {
                                    self.passwordUpdate(user: user)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } else {
                            showToast(view: self.view, message: "請輸入正確的密碼")
                        }
                    }
                }  else {
                    print(error!.localizedDescription)
                }
            }
        }  else {
            showToast(view: view, message: "請先註冊")
        }
    }
    
    func passwordUpdate(user: UserInfo) {
        var requestParam = [String: String]()
        requestParam["action"] = "passwordUpdate"
        requestParam["user"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
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
                                showSimpleAlert(message: "密碼修改成功", viewController: self)
                            } else {
                                showToast(view: self.view, message: "更新失敗")
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
