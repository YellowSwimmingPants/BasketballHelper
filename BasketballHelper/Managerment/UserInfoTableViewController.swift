//
//  UserInfoTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class UserInfoTableViewController: UITableViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var userInfo: UserInfo!
    let url_server = URL(string: common_url + "UserInfoServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userInfo.userName
        accountLabel.text = userInfo.userAccount
        nameLabel.text = userInfo.userName
        emailLabel.text = userInfo.email
        showImage()
    }
    
    func showImage() {
        var requestParam = [String: String]()
        let userAccount = userInfo.userAccount
        requestParam = ["action" : "getImage"]
        requestParam["userAccount"] = userAccount
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
