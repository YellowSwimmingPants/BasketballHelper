//
//  ManagermentTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class ManagermentTableViewController: UITableViewController {
    
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

    @IBAction func clickLogout(_ sender: Any) {
        self.userDefault.set("", forKey: "userDefault")
        self.userDefault.set("", forKey: "teamInfo")
        self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
    }
    
}
