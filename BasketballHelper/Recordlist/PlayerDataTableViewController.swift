import UIKit

class PlayerDataTableViewController: UITableViewController {
    var actions = [Action]()
    var gameDatas: NSMutableArray?
    var gameData: GameDataCount?
    var playerName: String?
    var controller: SegmentBarViewController!
//    var delegate: StartingLineupViewController?
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
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        var gameDatas = delegate!.gameDatas
//        for i in 0..<gameDatas.count {
//            if gameDatas[i].PlayerID == gameData?.PlayerID && gameDatas[i].Period == gameData?.Period{
//                gameDatas[i] = gameData!
//                break
//            }
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "actionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ActionTableViewCell
        cell.lbActionName.text = actions[indexPath.row].actionName
        cell.lbActionCount.text = String(actions[indexPath.row].actionCount)
        cell.tag = indexPath.row
        
//        cell.textLabel?.text = action
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
    
    @IBAction func clickGiveup(_ sender: Any) {
//        for i in 0..<gameDatas!.count {
//            let gameDt = gameDatas![i] as! GameDataCount
//            if gameDt.PlayerID == gameData!.PlayerID {
//                gameDatas!.removeObject(at: i)
//                break
//            }
//        }
        
        gameDatas?.forEach({ (data) in
            print(data)
        })
        print("remove", gameData)
        
        gameDatas?.remove(gameData!)
//        controller = storyboard!.instantiateViewController(withIdentifier: "segController")
        self.navigationController?.popViewController(animated: true)
    }
}
