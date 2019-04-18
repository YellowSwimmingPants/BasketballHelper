//
//  TeamMemberViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class TeamMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var memberTableView: UITableView!
    let userDefault = UserDefaults()
    var userInfo = [UserInfo]()
    var users: UserInfo!
    let url_server = URL(string: common_url_user + "UserServlet")
    let url_server_manager = URL(string: common_url_user + "ManagersServlet")
    var managerList = [UserInfo]()
    var memberList = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefault.data(forKey: "userDefault") == nil {
            
        } else {
            tableViewAddRefreshControl()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            showManager()
            showMember()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch (segmentControl.selectedSegmentIndex) {
        case 0:
            returnValue = managerList.count
            break
        case 1:
            returnValue = memberList.count
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        let userAccountLabel = cell.viewWithTag(102) as! UILabel
        let userNameLabel = cell.viewWithTag(103) as! UILabel
        let userImageView = cell.viewWithTag(101) as! UIImageView
        switch (segmentControl.selectedSegmentIndex) {
        case 0:
            let userAccount = managerList[indexPath.row].userAccount
            let userName = managerList[indexPath.row].userName
            userAccountLabel.text = userAccount
            userNameLabel.text = userName
            showImage(userAccount, userImageView)
            break
        case 1:
            let userAccount =  memberList[indexPath.row].userAccount
            let userName = memberList[indexPath.row].userName
            userAccountLabel.text = userAccount
            userNameLabel.text = userName
            showImage(userAccount, userImageView)
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "退出球隊") { (action, indexPath) in
            
            let alertController = UIAlertController(title: "注意", message: "是否要將成員退出球隊", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (_) in
                var requestParam = [String: Any]()
                requestParam["action"] = "exitTeam"
                if self.segmentControl.selectedSegmentIndex == 0 {
                    requestParam["userAccount"] = self.managerList[indexPath.row].userAccount
                }
                if self.segmentControl.selectedSegmentIndex == 1 {
                    requestParam["userAccount"] = self.memberList[indexPath.row].userAccount
                }
                executeTask(self.url_server_manager!, requestParam, completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    if count != 0 {
                                        if self.segmentControl.selectedSegmentIndex == 0 {
                                            self.managerList.remove(at: indexPath.row)
                                            DispatchQueue.main.async {
                                                tableView.deleteRows(at: [indexPath], with: .fade)
                                            }
                                        }
                                        if self.segmentControl.selectedSegmentIndex == 1 {
                                            self.memberList.remove(at: indexPath.row)
                                            DispatchQueue.main.async {
                                                tableView.deleteRows(at: [indexPath], with: .fade)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancel)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        let priority = UITableViewRowAction(style: .destructive, title: "修改權限") { (action, indexPath) in
            
            let alertController = UIAlertController(title: "注意", message: "是否要修改權限", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (_) in
                var requestParam = [String: Any]()
                requestParam["action"] = "changePriority"
                if self.segmentControl.selectedSegmentIndex == 0 {
                    requestParam["userAccount"] = self.managerList[indexPath.row].userAccount
                    requestParam["priority"] = 1
                }
                if self.segmentControl.selectedSegmentIndex == 1 {
                    requestParam["userAccount"] = self.memberList[indexPath.row].userAccount
                    requestParam["priority"] = 0
                }
                executeTask(self.url_server!, requestParam, completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    DispatchQueue.main.async {
                                        if count != 0 {
                                            if self.segmentControl.selectedSegmentIndex == 0 {
                                                self.managerList.remove(at: indexPath.row)
                                                DispatchQueue.main.async {
                                                    tableView.deleteRows(at: [indexPath], with: .fade)
                                                }
                                            }
                                            if self.segmentControl.selectedSegmentIndex == 1 {
                                                self.memberList.remove(at: indexPath.row)
                                                DispatchQueue.main.async {
                                                    tableView.deleteRows(at: [indexPath], with: .fade)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancel)
            alertController.addAction(ok)
             self.present(alertController, animated: true, completion: nil)
            
            
        }
        priority.backgroundColor = UIColor.lightGray
        if users.priority == 1 {
            return [delete, priority]
        }
        return []
    }

    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")
        refreshControl.addTarget(self, action: #selector(showManager), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(showMember), for: .valueChanged)
        self.memberTableView.refreshControl = refreshControl
    }
    
    @objc func showManager() {
        var requestParam = [String: Any]()
        requestParam["action"] = "getManager"
        requestParam["teamInfo"] = users.teamInfo
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([UserInfo].self, from: data!) {
                        self.managerList = result
                        DispatchQueue.main.async {
                            if let control = self.memberTableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                           //  抓到資料後重刷table view 
                            self.memberTableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @objc func showMember() {
        var requestParam = [String: Any]()
        requestParam["action"] = "getMember"
        requestParam["teamInfo"] = users.teamInfo
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([UserInfo].self, from: data!) {
                        self.memberList = result
                        DispatchQueue.main.async {
                            if let control = self.memberTableView.refreshControl {
                                if control.isRefreshing {
                                    control.endRefreshing()
                                }
                            }
                            self.memberTableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func showImage(_ userAccount: String, _ userImageView: UIImageView) {
        var requestParam = [String: Any]()
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
                    image = UIImage(named: "managerment")
                }
                DispatchQueue.main.async {
                    userImageView.image = image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    @IBAction func segmentedControlActionChanged(_ sender: Any) {
        if userDefault.data(forKey: "userDefault") == nil {
            
        } else {
            showManager()
            showMember()
            memberTableView.reloadData()
        }
    }
}
