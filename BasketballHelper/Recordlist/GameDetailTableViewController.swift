import UIKit

class GameDetailTableViewController: UITableViewController {
    var game: Game!
    var players = [Page_playerList]()
    let url_server = URL(string: common_url_playerInfo + "GameServlet")
    var users: UserInfo!
    var userInfo: UserInfo!
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = game.gameName
    }

    override func viewWillAppear(_ animated: Bool) {
        let userInfo = userDefault.data(forKey: "userDefault")
        //TODO:
//        users = UserInfo(2, "mark", "123", "mark", "k@gmail.com", 1, "CP103");
        users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
        showAllPlayers()
    }

    @objc func showAllPlayers(){
        //要改為只顯示該場比賽的
        var requestParam = [String : Any]()
        requestParam = ["action" : "getGamePlayer"]
        requestParam["gameID"] = "\(game.id)"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")

                    if let result = try? JSONDecoder().decode([Page_playerList].self, from: data!) {
                        self.players = result
                        DispatchQueue.main.async {
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "playerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let player = players[indexPath.row]
        //        cell?.textLabel?.text = player.name
        cell?.textLabel?.text = player.name
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerGameDataSegue" {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let player = players[indexPath!.row]
            let playerDataCountVC = segue.destination as? PlayerDataCountViewController
            playerDataCountVC!.player = player
            playerDataCountVC?.game = game
        } else if segue.identifier == "PeriodFromDBSegue" {
            let PeriodFromDBTVC = segue.destination as? PeriodFromDBTableViewController
            PeriodFromDBTVC?.game = game
        }
    }
    
}
