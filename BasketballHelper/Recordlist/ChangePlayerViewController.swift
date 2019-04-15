import UIKit

class ChangePlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var players = [Page_playerList]()
    var isSelected = [Bool]()
    let url_server = URL(string: common_url + "PlayerServlet")
    var startingLineup: NSMutableArray?
    var count = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("row", indexPath.row)
        let cellId = "changePlayerCellID"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        //RESET CELL
        //SET CELL
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        
        
        
////   var isSelect = false
//        for i in 0..<startingLineup!.count {
//            let starting = startingLineup![i] as! Page_playerList
//            print("compare ", starting.id, player.id)
//            if player.id == starting.id {
//                isSelected[indexPath.row] = true
////                isSelect = true;
//                break;
//            }
//        }
        
        if isSelected[indexPath.row] {
            cell.accessoryType = .checkmark
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        } else {
            cell.accessoryType = .none
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
        
        
//        for i in 0..<isSelected.count {
//            if isSelected[i] == true {
//                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
//                cell.accessoryType = .checkmark
//            } else {
//                self.tableView.deselectRow(at: indexPath, animated: false)
//                cell.accessoryType = .none
//            }
//        }
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        count = (startingLineup?.count)!
        tableView.allowsMultipleSelection = true
        
        showAllPlayers()

        for i in 0..<startingLineup!.count {
            let starting = startingLineup![i] as! Page_playerList

            for (i, player) in players.enumerated() {
                if player.playerID == starting.playerID {
                    isSelected[i] = true
                    break
                }
            }
        }
    }
    
    
    func setArrayValue() {
        for _ in 0..<players.count {
        isSelected.append(false)
        }
    }
    
    //    * tableView加上下拉更新功能
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")//attributedTitle標題屬性
        refreshControl.addTarget(self, action: #selector(showAllPlayers), for: .valueChanged)
        //addTarget 指下拉動作做觸發
        self.tableView.refreshControl = refreshControl
    }

    @objc func showAllPlayers() {
        let requestParam = ["action" : "getAll"]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                count += 1
                if count <= 5 {
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.accessoryType = .checkmark
                    startingLineup!.add(players[indexPath.row])
                    isSelected[indexPath.row] = true
                } else {
                    count = 5
                    showSimpleAlert(message: "只能選取5人！", viewController: self)
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        count -= 1
        for i in 0..<startingLineup!.count {
            let starting = startingLineup![i] as! Page_playerList
            if starting.playerID == players[indexPath.row].playerID{
                startingLineup?.removeObject(at: i)
                isSelected[indexPath.row] = false

                break
            }
        }
    }
    
}
