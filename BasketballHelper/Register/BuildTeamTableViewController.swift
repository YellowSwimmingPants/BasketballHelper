//
//  BuildTeamTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class BuildTeamTableViewController: UITableViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    let url_server = URL(string: common_url_user + "UserServlet")
    let userDefault = UserDefaults()
    var userInfos = [UserInfo]()
    var users: UserInfo!
    var viewController = UIViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
        }
        
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let name = teamNameTextField.text == nil ? "" : teamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if name!.isEmpty {
            showToast(view: self.view, message: "請輸入隊名")
            return
        }
        let userAccount = users.userAccount
        var teamInfo = [String : String]()
        teamInfo["action"] = "create"
        teamInfo["teamName"] = name
        teamInfo["userAccount"] = userAccount
        executeTask(url_server!, teamInfo) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    self.userDefault.set(name, forKey: "teamInfo")
                                    self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Homepage")
                                } else {
                                    showToast(view: self.view, message: "建立失敗")
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
    
    
    @IBAction func clickSkip(_ sender: Any) {
        self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Homepage")
    }
}
