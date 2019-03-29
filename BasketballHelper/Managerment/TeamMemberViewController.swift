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
    var userInfo = [UserInfo]()
    let url_server = URL(string: common_url_user + "ManagersServlet")
    
    let privateList:[String] = ["Private item 1","Private item 2"]
    let friendsAndFamily:[String] = ["Friend item 1","Friend item 2", "Friends item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch (segmentControl.selectedSegmentIndex) {
        case 0:
            returnValue = privateList.count
            break
        case 1:
            returnValue = friendsAndFamily.count
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
            cell.textLabel?.text = privateList[indexPath.row]
            break
        case 1:
            cell.textLabel?.text = friendsAndFamily[indexPath.row]
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "退出球隊") { (action, indexPath) in
            var requestParam = [String: Any]()
            requestParam["action"] = "memberDelete"
            requestParam["userAccount"] = self.userInfo[indexPath.row].userAccount
            executeTask(self.url_server!, requestParam, completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                if count != 0 {
                                    self.userInfo.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .fade)
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

    
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    @IBAction func segmentedControlActionChanged(_ sender: Any) {
        memberTableView.reloadData()
    }
    
    @IBAction func clickInvite(_ sender: Any) {
    }
    
}
