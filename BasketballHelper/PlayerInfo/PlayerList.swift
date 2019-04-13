
import UIKit

class PlayerList: UITableViewController {
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    var players = [Page_playerList]()
    let userDefault = UserDefaults()
    var users: UserInfo!
    var userInfo: UserInfo!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        
    }
    
      /** tableView加上下拉更新功能 */
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
    
   /* UITableViewDataSource的方法，定義表格的區塊數，預設值為1 */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "playerCell"
        // tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別SpotCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayerCell
        let player = players[indexPath.row]

        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["playerID"] = player.playerID
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4//圖片顯示寬度除5
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
        cell.lbName.text = player.name
        cell.lbNickname.text = player.nickname
        return cell
    }
    
    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .default, title: "\u{2699}\n edit", handler: { (action, indexPath) in
            let playerUpdate = self.storyboard?.instantiateViewController(withIdentifier: "playerUpdate") as! PlayerUpdate
            let player = self.players[indexPath.row]
            playerUpdate.player = player
            self.navigationController?.pushViewController(playerUpdate, animated: true)
        })
        edit.backgroundColor = UIColor(red: 189/255, green: 255/255, blue: 255/255, alpha: 1)

        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "\u{1f5d1}\n Delete", handler: { (action, indexPath) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "playerDelete"
            requestParam["playerId"] = self.players[indexPath.row].playerID
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.players.remove(at: indexPath.row)
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? PlayerDetail
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.playerList = players[row]
        }
    }


 

}
