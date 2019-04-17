//
//  HomepageViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.

import UIKit

class HomepageViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let url_server = URL(string: common_url_user + "UserServlet")
    let userDefault = UserDefaults()
    var viewController = UIViewController()
    var users: UserInfo!
    var user = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            login(account: users.userAccount, password: users.userPassword)
        }
        accountTextField.text = ""
        passwordTextField.text = ""
        addKeyboardObserver()
    }
    
    func login(account: String, password: String) {
        var userInfo = [String : String]()
        userInfo["action"] = "login"
        userInfo["userAccount"] = account
        userInfo["userPassword"] = password
        executeTask(url_server!, userInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([String : String].self, from: data!) {
                        print(result)
                        DispatchQueue.main.async {
                            if result["success"] == "Yes" {
                                let userLogin = result["userInfo"]
                                let login = try? JSONDecoder().decode(UserInfo.self, from: userLogin!.data(using: .utf8)!)
                                let loginOK = try! JSONEncoder().encode(login)
                                self.userDefault.set(loginOK, forKey: "userDefault")
                                self.userDefault.synchronize()
                                if login?.teamInfo != "" {
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Homepage")
                                    self.present(self.viewController, animated: true, completion: nil)
                                } else {
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "JoinTeam")
                                    self.present(self.viewController, animated: true, completion: nil)
                                }
                            } else {
                                showToast(view: self.view, message: "登入失敗")
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let account = accountTextField.text == nil ? "" : accountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text == nil ? "" : passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if account!.isEmpty || password!.isEmpty {
            showSimpleAlert(message: "請輸入正確的帳號密碼", viewController: self)
            return
        }
        login(account: account!, password: password!)
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
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
}
