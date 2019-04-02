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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userInfo = userDefault.data(forKey: "userDefault")
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
        let teamInfo = users.teamInfo
        showManager(teamInfo: teamInfo)
        showMember(teamInfo: teamInfo)
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
        switch (segmentControl.selectedSegmentIndex) {
        case 0:
            cell.textLabel?.text = managerList[indexPath.row].userAccount
            break
        case 1:
            cell.textLabel?.text = memberList[indexPath.row].userAccount
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "退出球隊") { (action, indexPath) in
            var requestParam = [String: Any]()
            requestParam["action"] = "quitTeam"
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
        return [delete]
    }
    
    func showManager(teamInfo: String) {
        var requestParam = [String: Any]()
        requestParam["action"] = "getManager"
        requestParam["teamInfo"] = teamInfo
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([UserInfo].self, from: data!) {
                        self.managerList = result
                        DispatchQueue.main.async {
                            self.memberTableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func showMember(teamInfo: String) {
        var requestParam = [String: Any]()
        requestParam["action"] = "getMember"
        requestParam["teamInfo"] = teamInfo
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([UserInfo].self, from: data!) {
                        self.memberList = result
                        DispatchQueue.main.async {
                            self.memberTableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func deleteMember() {
        
    }
    
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    @IBAction func segmentedControlActionChanged(_ sender: Any) {
        memberTableView.reloadData()
    }
    
    @IBAction func clickInvite(_ sender: Any) {
    }
    
}
