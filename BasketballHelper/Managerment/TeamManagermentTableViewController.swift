//
//  TeamManagermentTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class TeamManagermentTableViewController: UITableViewController {
    
    let url_server = URL(string: common_url + "UserInfoServlet")
    let userDefault = UserDefaults()
    var userInfos = [UserInfo]()
    var users: UserInfo!
    var viewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = userDefault.data(forKey: "userDefault")
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            exitTeam()
        } else {
            quitTeam()
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
                                    self.userDefault.set("", forKey: "teamInfo")
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
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
        teamInfo["userAccount"] = users.userAccount
        executeTask(url_server!, teamInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
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
