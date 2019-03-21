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
    var userInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func clickSave(_ sender: Any) {
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
        let user = UserInfo(userId: userInfo.userId, userInfo.userAccount, newPassword, userInfo.userName, userInfo.email, userInfo.priority)
        var requestParam = [String: String]()
        requestParam["action"] = "updatePassword"
        requestParam["user"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
}
