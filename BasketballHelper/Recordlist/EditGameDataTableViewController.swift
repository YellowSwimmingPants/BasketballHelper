import UIKit

class EditGameDataTableViewController: UITableViewController {
    var actions = [Action]()
    var playerName: String?
    var gameData: GameDataCount?
    let url_server = URL(string: common_url_user + "PlayerServlet")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = playerName
        actions.append(Action("罰球進球", gameData!.FT!))
        actions.append(Action("罰球不進", gameData!.FTL!))
        actions.append(Action("2分進球", gameData!.FG!))
        actions.append(Action("2分不進", gameData!.FGL!))
        actions.append(Action("3分進球", gameData!.TPM!))
        actions.append(Action("3分不進", gameData!.TPL!))
        actions.append(Action("犯規", gameData!.Foul!))
        actions.append(Action("進攻籃板", gameData!.OfnReb!))
        actions.append(Action("防守籃板", gameData!.DefReb!))
        actions.append(Action("失誤", gameData!.TurnOver!))
        actions.append(Action("抄截", gameData!.Steal!))
        actions.append(Action("助攻", gameData!.Assist!))
        actions.append(Action("阻攻", gameData!.Block!))
        tableView.reloadData()
        showData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "actionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ActionTableViewCell
        cell.lbActionName.text = actions[indexPath.row].actionName
        cell.lbActionCount.text = String(actions[indexPath.row].actionCount)
        cell.tag = indexPath.row
        return cell
    }

    func updateData(_ index: Int?) {
        if actions[index!].actionName == "罰球進球" {
            gameData!.FT! = actions[index!].actionCount
        } else if actions[index!].actionName == "罰球不進"{
            gameData!.FTL! = actions[index!].actionCount
        } else if actions[index!].actionName == "2分進球"{
            gameData!.FG! = actions[index!].actionCount
        } else if actions[index!].actionName == "2分不進"{
            gameData!.FGL! = actions[index!].actionCount
        } else if actions[index!].actionName == "3分進球"{
            gameData!.TPM! = actions[index!].actionCount
        } else if actions[index!].actionName == "3分不進"{
            gameData!.TPL! = actions[index!].actionCount
        } else if actions[index!].actionName == "犯規"{
            gameData!.Foul! = actions[index!].actionCount
        } else if actions[index!].actionName == "進攻籃板"{
            gameData!.OfnReb! = actions[index!].actionCount
        } else if actions[index!].actionName == "防守籃板"{
            gameData!.DefReb! = actions[index!].actionCount
        } else if actions[index!].actionName == "失誤"{
            gameData!.TurnOver! = actions[index!].actionCount
        } else if actions[index!].actionName == "抄截"{
            gameData!.Steal! = actions[index!].actionCount
        } else if actions[index!].actionName == "助攻"{
            gameData!.Assist! = actions[index!].actionCount
        } else if actions[index!].actionName == "阻攻"{
            gameData!.Block! = actions[index!].actionCount
        }
    }
    
    func loadCountData(_ index: Int?, _ data: Data) {
        gameData = try? JSONDecoder().decode(GameDataCount.self, from: data)
        if actions[index!].actionName == "罰球進球" {
            actions[index!].actionCount = gameData!.FT!
        } else if actions[index!].actionName == "罰球不進"{
            actions[index!].actionCount = gameData!.FTL!
        } else if actions[index!].actionName == "2分進球"{
            actions[index!].actionCount = gameData!.FG!
        } else if actions[index!].actionName == "2分不進"{
            actions[index!].actionCount = gameData!.FGL!
        } else if actions[index!].actionName == "3分進球"{
            actions[index!].actionCount = gameData!.TPM!
        } else if actions[index!].actionName == "3分不進"{
            actions[index!].actionCount = gameData!.TPL!
        } else if actions[index!].actionName == "犯規"{
            actions[index!].actionCount = gameData!.Foul!
        } else if actions[index!].actionName == "進攻籃板"{
            actions[index!].actionCount = gameData!.OfnReb!
        } else if actions[index!].actionName == "防守籃板"{
            actions[index!].actionCount = gameData!.DefReb!
        } else if actions[index!].actionName == "失誤"{
            actions[index!].actionCount = gameData!.TurnOver!
        } else if actions[index!].actionName == "抄截"{
            actions[index!].actionCount = gameData!.Steal!
        } else if actions[index!].actionName == "助攻"{
            actions[index!].actionCount = gameData!.Assist!
        } else if actions[index!].actionName == "阻攻"{
            actions[index!].actionCount = gameData!.Block!
        }
    }
    
    @IBAction func clickMinus(_ sender: UIButton) {
        let index = sender.superview?.superview?.tag
        //        print(sender.superview?.superview?.tag)
        if(actions[index!].actionCount > 0){
            actions[index!].actionCount -= 1
        } else {
            actions[index!].actionCount = 0
        }
        
        updateData(index)
        
        let tableViewCell = sender.superview?.superview as! ActionTableViewCell
        tableViewCell.lbActionCount.text = String(actions[index!].actionCount)
        
    }
    
    @IBAction func clickPlus(_ sender: UIButton) {
        //        print(sender.superview?.superview?.tag)
        let index = sender.superview?.superview?.tag
        actions[index!].actionCount += 1
        updateData(index)
        let tableViewCell = sender.superview?.superview as! ActionTableViewCell
        tableViewCell.lbActionCount.text = String(actions[index!].actionCount)
    }
    
    @IBAction func clickSave(_ sender: Any) {
        
    }
    
    @objc func showData(){
        var requestParam = [String : Any]()
        requestParam["action"] = "getPeriodData"
//        requestParam["playerID"] =
//        requestParam["period"] =
//        requestParam["game"] =
        
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    DispatchQueue.main.async {
//                        self.loadCountData(<#T##index: Int?##Int?#>, data)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    
}
