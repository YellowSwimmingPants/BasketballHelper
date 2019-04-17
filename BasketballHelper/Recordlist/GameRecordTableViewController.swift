import UIKit

class GameRecordTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet weak var searchBar: UISearchBar!
    let url_server = URL(string: common_url_user + "GameServlet")
    var games = [Game]()
    var searchedGames = [Game]()
    var searchDataList: [String] = [String]() // 搜尋結果集合
    var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    //test
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        tableViewAddRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllGames()
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
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            return self.searchDataList.count
        } else {
            return games.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "gameCell"
        
        /*如果捲動表格，表格一邊會增加一列儲存格，另一邊則會消失一列儲存格，消失的儲存格其實是被移出佇列(dequeue)，如果能重複使用消失儲存格，就能節省記憶體空間；而且可避免建立與釋放儲存格空間的動作，可以提升效能 */
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            cell.textLabel?.text = String(searchDataList[indexPath.row])
            cell.detailTextLabel?.text = String(searchDataList[indexPath.row])
        } else {
            let game = games[indexPath.row]
            cell.textLabel?.text = game.gameName
            cell.detailTextLabel?.text = game.gameDate
        }
        
        return cell
    }
    
    // 當在searchBar上開始輸入文字時
    // 當「準備要在searchBar輸入文字時」、「輸入文字時」、「取消時」三個事件都會觸發該delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
//        if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count == 0 {
//            return
//        }
//        self.filterDataSource()
//    }
    
    // 過濾被搜陣列裡的資料
//    func filterDataSource() {
//        // 使用高階函數來過濾掉陣列裡的資料
//        self.filterDataList = searchedDataSource.filter({ (fruit) -> Bool in
//            return fruit.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
//        })
//
//        if self.filterDataList.count > 0 {
//            self.isShowSearchResult = true
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
//        } else {
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none // 移除TableView的格線
//            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
//            // ...
//        }
//
//        self.tableView.reloadData()
//    }
    
    func searchGame() {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let updateGameTVC = self.storyboard?.instantiateViewController(withIdentifier: "updateGameTVC") as! UpdateGameTableViewController
            let game = self.games[indexPath.row]
            updateGameTVC.game = game
            self.navigationController?.pushViewController(updateGameTVC, animated: true)
        })
        edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "gameDelete"
            requestParam["gameId"] = self.games[indexPath.row].id
            requestParam["gameData"] = self.games[indexPath.row].id
            executeTask(self.url_server!, requestParam
                , completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.games.remove(at: indexPath.row)
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

