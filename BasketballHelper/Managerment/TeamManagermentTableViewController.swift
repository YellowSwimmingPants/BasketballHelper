//
//  TeamManagermentTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
// 01

import UIKit

class TeamManagermentTableViewController: UITableViewController {
    
    let url_server = URL(string: common_url_user + "ManagersServlet")
    let userDefault = UserDefaults()
    var userInfo = [UserInfo]()
    var users: UserInfo!
    var viewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "注意", message: "請是否要離開球隊", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (_) in
                self.exitTeam()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancel)
            alertController.addAction(ok)
            /* 呼叫present()才會跳出Alert Controller */
            if userDefault.data(forKey: "userDefault") == nil {
                showToast(view: view, message: "請先註冊")
            } else {
                self.present(alertController, animated: true, completion:nil)
            }
        } else {
            let alertController = UIAlertController(title: "注意", message: "是否要解散球隊", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (_) in
                if self.users.priority == 1 {
                    self.quitTeam()
                } else {
                    showToast(view: self.view, message: "沒有權限")
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancel)
            alertController.addAction(ok)
            /* 呼叫present()才會跳出Alert Controller */
            if userDefault.data(forKey: "userDefault") == nil {
                showToast(view: view, message: "請先註冊")            } else {
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    func exitTeam() {
        var teamInfo = [String: String]()
        teamInfo["action"] = "exitTeam"
        teamInfo["userAccount"] = users.userAccount
        executeTask(url_server!, teamInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    let userDefault = UserDefaults.standard
                                    let dics = userDefault.dictionaryRepresentation()
                                    for key in dics {
                                        userDefault.removeObject(forKey: key.key)
                                    }
                                    userDefault.synchronize()
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
                                    self.present(self.viewController, animated: true, completion: nil)
                                } else {
                                    showToast(view: self.view, message: "退出球隊失敗")
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
    
    func quitTeam() {
        var teamInfo = [String: String]()
        teamInfo["action"] = "quitTeam"
        teamInfo["teamInfo"] = users.teamInfo
        executeTask(url_server!, teamInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    let userDefault = UserDefaults.standard
                                    let dics = userDefault.dictionaryRepresentation()
                                    for key in dics {
                                        userDefault.removeObject(forKey: key.key)
                                    }
                                    userDefault.synchronize()
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
                                    self.present(self.viewController, animated: true, completion: nil)
                                } else {
                                    showToast(view: self.view, message: "解散球隊失敗")
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
