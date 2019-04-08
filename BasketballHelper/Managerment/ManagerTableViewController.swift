//
//  ManagerTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class ManagerTableViewController: UITableViewController {
    
    let userDefault = UserDefaults()
    var userInfos = [UserInfo]()
    var users: UserInfo!


    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
        }
    }
}
