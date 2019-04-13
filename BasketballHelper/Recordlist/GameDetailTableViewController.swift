//
//  GameDetailTableViewController.swift
//  BasketballHelper
//
//  Created by 李宜銓 on 2019/4/10.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class GameDetailTableViewController: UITableViewController {
    var game: Game!
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
//    var players = [Page_playerList]()
    var players = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = game.gameName
    }

//    override func viewWillAppear(_ animated: Bool) {
//        showAllPlayers()
//    }
//
//    @objc func showAllPlayers(){
//        //要改為只顯示該場比賽的
//        let requestParam = ["action" : "getAll"]
//        executeTask(url_server!, requestParam) { (data, response, error) in
//            if error == nil {
//                if data != nil {
//                    // 將輸入資料列印出來除錯用
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
//
//                    if let result = try? JSONDecoder().decode([Page_playerList].self, from: data!) {
//                        self.players = result
//                        DispatchQueue.main.async {
//                            print("1+\(self.players)")
////                            if let control = self.tableView.refreshControl {
////                                if control.isRefreshing {
////                                    // 停止下拉更新動作
////                                    control.endRefreshing()
////                                }
////                            }
//                            /* 抓到資料後重刷table view */
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }

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
        cell?.textLabel?.text = player
        return cell!
    }
    
}
