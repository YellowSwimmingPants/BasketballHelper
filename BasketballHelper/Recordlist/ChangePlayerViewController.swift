import UIKit

class ChangePlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var players = [Player]()
//    let url_server = URL(string: common_url + "PlayerServlet")
    
    var players = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "changePlayerCellID"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let player = players[indexPath.row]
        cell.textLabel?.text = player
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllPlayers()
    }

    @objc func showAllPlayers() {
//        let requestParam = ["action" : "getAll"]
//        executeTask(url_server!, requestParam) { (data, response, error) in
//            if error == nil {
//                if data != nil {
//                    // 將輸入資料列印出來除錯用
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
//
//                    if let result = try? JSONDecoder().decode([Spot].self, from: data!) {
//                        self.spots = result
//                        DispatchQueue.main.async {
//                            if let control = self.tableView.refreshControl {
//                                if control.isRefreshing {
//                                    // 停止下拉更新動作
//                                    control.endRefreshing()
//                                }
//                            }
//                            /* 抓到資料後重刷table view */
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
    }
    
}
