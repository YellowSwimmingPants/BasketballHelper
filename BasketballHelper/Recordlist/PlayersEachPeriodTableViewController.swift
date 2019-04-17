import UIKit

class PlayersEachPeriodTableViewController: UITableViewController {
    var period: Int!
    var players = [Page_playerList]()
    let url_server = URL(string: common_url_playerInfo + "GameServlet")
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第" + String(period) + "節"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllPlayers()
    }
    
    @objc func showAllPlayers(){
        var requestParam = [String:Any] ()
        requestParam = ["action" : "getPlayerEachPeriod"]
        requestParam["gameID"] = game.id
        requestParam["period"] = period
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "playerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let player = players[indexPath.row]
        //        cell?.textLabel?.text = player.name
        cell?.textLabel?.text = player.name
        return cell!
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (players.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PlayerEachPeriodDataViewController {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let player = players[indexPath!.row]
            controller.player = player
            controller.game = game
            controller.period = period
        }
    }
}
