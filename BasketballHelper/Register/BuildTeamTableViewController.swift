//
//  BuildTeamTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/4/8.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class BuildTeamTableViewController: UITableViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    let url_server = URL(string: common_url_user + "ManagersServlet")
    let userDefault = UserDefaults()
    var userInfos = [UserInfo]()
    var users: UserInfo!
    var viewController = UIViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = userDefault.data(forKey: "userDefault")
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let name = teamNameTextField.text == nil ? "" : teamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if name!.isEmpty {
            showToast(view: self.view, message: "請輸入隊名")
            return
        }
        var teamInfo = [String : String]()
        teamInfo["action"] = "createTeam"
        teamInfo["teamInfo"] = name
        teamInfo["userAccount"] = users.userAccount
        teamInfo["userPassword"] = users.userPassword
        executeTask(url_server!, teamInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([String : String].self, from: data!) {
                        DispatchQueue.main.async {
                            if result["success"] == "Yes" {
                                let userInfo = result["userInfo"]
                                let login = try? JSONDecoder().decode(UserInfo.self, from: userInfo!.data(using: .utf8)!)
                                let loginOK = try! JSONEncoder().encode(login)
                                self.userDefault.set(loginOK, forKey: "userDefault")
                                self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Homepage")
                                self.present(self.viewController, animated: true, completion: nil)
                            } else {
                                showToast(view: self.view, message: "建立失敗")
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
    
    
    @IBAction func clickSkip(_ sender: Any) {
        self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Homepage")
        self.present(self.viewController, animated: true, completion: nil)
    }
}
