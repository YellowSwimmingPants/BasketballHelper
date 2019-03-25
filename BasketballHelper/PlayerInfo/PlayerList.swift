//
//  PlayerList.swift
//  BasketballHelper
//
//  Created by 陳南宇 on 2019/3/19.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class PlayerList: UITableViewController {
    let user = UserDefaults.standard
    let url_server = URL(string: common_url + "PlayerList")
    var player = [Page_playerList]()
    var imageUpload: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
//        self.user.set(<#T##value: Any?##Any?#>, forKey: "<#T##String#>")
//        self.user.synchronize()
    }
    
      /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")//attributedTitle標題屬性
        refreshControl.addTarget(self, action: #selector(showAllPlayers), for: .valueChanged)
        //addTarget 指下拉動作做觸發
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllPlayers()
    }
    
    @objc func showAllPlayers(){
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([String:String].self, from: data!) {
                        let player = result["key"]
                        if player == "true"{
                        }
                        DispatchQueue.main.async {
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
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "playerCell"
        // tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別SpotCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayerCell
        let players = player[indexPath.row]

        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = players.name
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4//圖片顯示寬度除4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { cell.ivPhoto.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        cell.lbName.text = players.name
        cell.lbNickname.text = players.name
        return cell
    }
    
    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let playerUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "playerUpdateVC") as! PlayerList
            let players = self.player[indexPath.row]
            playerUpdateVC.player = [players]//沒有中括號
            self.navigationController?.pushViewController(playerUpdateVC, animated: true)
        })
        edit.backgroundColor = UIColor.lightGray

        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "spotDelete"
            requestParam["playerId"] = self.player[indexPath.row].name
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.player.remove(at: indexPath.row)
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
        })
        return [delete, edit]
    }

    /* 因為拉UITableViewCell與detail頁面連結，所以sender是UITableViewCell */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "spotDetail" {
//            /* indexPath(for:)可以取得UITableViewCell的indexPath */
//            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
//            let players = player[indexPath!.row]
//            let detailVC = segue.destination as! PlayerDetail
//            detailVC.spot = players
//        }
//    }




}
