//
//  HomepageViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let url_server = URL(string: common_url + "UserInfoServlet")
    let userDefault = UserDefaults()
    var viewController = UIViewController()
    var users: UserInfo!
    var user = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            
        }
    }
    
    func signIn(account: String, password: String) {
        var userInfo = [String : String]()
        userInfo["action"] = "login"
        userInfo["userAccount"] = account
        userInfo["userPassword"] = password
        executeTask(url_server!, userInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([String : String].self, from: data!) {
                        DispatchQueue.main.async {
                            if result["success"] == "Yes" {
                                
                                
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    

    @IBAction func clickSignIn(_ sender: Any) {
        let account = accountTextField.text == nil ? "" : accountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text == nil ? "" : passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if account!.isEmpty || password!.isEmpty {
            showSimpleAlert(message: "請輸入正確的帳號密碼", viewController: self)
            return
        }
    }
    

}
