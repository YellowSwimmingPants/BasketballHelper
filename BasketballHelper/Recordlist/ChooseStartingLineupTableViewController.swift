import UIKit

class ChooseStartingLineupTableViewController: UITableViewController {
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    var players = [Page_playerList]()
    var count = 0
    var startingLineup: NSMutableArray!
    var delegate: CreateGameTableViewController?
    var users: UserInfo!
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        tableView.allowsMultipleSelection = true
    }
    
//    * tableView加上下拉更新功能
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")//attributedTitle標題屬性
        refreshControl.addTarget(self, action: #selector(showAllPlayers), for: .valueChanged)
        //addTarget 指下拉動作做觸發
        self.tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        let userInfo = userDefault.data(forKey: "userDefault")
       
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
        showAllPlayers()
    }

    @objc func showAllPlayers(){
        var requestParam = [String:Any] ()
        requestParam = ["action" : "getAll"]
        requestParam["teamID"] = users.teamInfo
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")

                    if let result = try? JSONDecoder().decode([Page_playerList].self, from: data!) {
                        self.players = result
                        DispatchQueue.main.async {
                            print("1+\(self.players)")
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "playerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let player = players[indexPath.row]
        cell?.textLabel?.text = player.name

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView?.cellForRow(at: indexPath)
        count += 1
        if count <= 5 {
            cell?.accessoryType = .checkmark
//                tableView.reloadData()
            startingLineup.add(players[indexPath.row])
        } else {
            count = 5
            showSimpleAlert(message: "只能選取5人！", viewController: self)
            self.tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView?.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        count -= 1
        for i in 0..<startingLineup.count {
            let starting = startingLineup[i] as! Page_playerList
            if starting.playerID == players[indexPath.row].playerID{
                startingLineup.removeObject(at: i)
                break
            }
        }
    }
    
//    func saveData() {
//        if self.delegate != nil {
//            delegate!.startingLineup = startingLineup
//        }
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(startingLineup, forKey: "startingLineup")
//        userDefaults.synchronize()
}
    
    

