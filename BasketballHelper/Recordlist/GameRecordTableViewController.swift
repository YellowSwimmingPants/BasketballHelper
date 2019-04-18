import UIKit

class GameRecordTableViewController: UITableViewController, UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    let url_server = URL(string: common_url_user + "GameServlet")
    var games = [Game]()
    var currentGames = [Game]()
    let userDefault = UserDefaults()
    var users: UserInfo!
    var userInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addKeyboardObserver()
        tableViewAddRefreshControl()
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            showAllGames()
        }
        searchBar.text = nil
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueCreate" {
            let userInfo = userDefault.data(forKey: "userDefault")
            if userInfo != nil {
                return true
            } else {
                showToast(view: self.view, message: "請先註冊")
                return false
            }
        }
        return true
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")
            //attributedTitle標題屬性
        refreshControl.addTarget(self, action: #selector(showAllGames), for: .valueChanged)
        //addTarget 指下拉動作做觸發
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func showAllGames(){
        //TODO:
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([Game].self, from: data!) {
                        self.games = result
                        self.currentGames = self.games
                        DispatchQueue.main.async {
                            print("1+\(self.games)")
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
        return currentGames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "gameCell"
        
        /*如果捲動表格，表格一邊會增加一列儲存格，另一邊則會消失一列儲存格，消失的儲存格其實是被移出佇列(dequeue)，如果能重複使用消失儲存格，就能節省記憶體空間；而且可避免建立與釋放儲存格空間的動作，可以提升效能 */
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!

//        let game = games[indexPath.row]
        cell.textLabel?.text = currentGames[indexPath.row].gameName
        cell.detailTextLabel?.text = currentGames[indexPath.row].gameDate
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentGames = games
            self.tableView.reloadData()
            return
        }
        currentGames = games.filter({ Game -> Bool in
            Game.gameName.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }

    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let updateGameTVC = self.storyboard?.instantiateViewController(withIdentifier: "updateGameTVC") as! UpdateGameTableViewController
            let game = self.currentGames[indexPath.row]
            updateGameTVC.game = game
            self.navigationController?.pushViewController(updateGameTVC, animated: true)
        })
        edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "gameDelete"
            requestParam["gameId"] = self.currentGames[indexPath.row].id
            requestParam["gameData"] = self.currentGames[indexPath.row].id
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.currentGames.remove(at: indexPath.row)
                                        DispatchQueue.main.async {
                                            tableView.deleteRows(at: [indexPath], with: .fade)
                                            self.showAllGames()
                                            self.searchBar.text = nil
//                                            self.tableView.reloadData()
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
        if segue.identifier == "gameDetail" {
            /* indexPath(for:)可以取得UITableViewCell的indexPath */
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let game = games[indexPath!.row]
            let gameDetailTVC = segue.destination as? GameDetailTableViewController
            gameDetailTVC!.game = game
        } 
    }
    
}

extension GameRecordTableViewController {
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight / 2
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

