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
    let userDefault = UserDefaults()
    var users: UserInfo!
    var userInfo: UserInfo!
    let url_server = URL(string: common_url_user + "UserServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            self.title = users.userName
            accountLabel.text = users.userAccount
            nameLabel.text = users.userName
            emailLabel.text = users.email
            showImage()
        } else {
            self.title = ""
            accountLabel.text = ""
            nameLabel.text = ""
            emailLabel.text = ""
            
        }
    }
    
    func showImage() {
        var requestParam = [String: Any]()
        let userAccount = users.userAccount
        requestParam["action"] = "getImage"
        requestParam["userAccount"] = userAccount
        requestParam["imageSize"] = userImageView.frame.width*2
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
