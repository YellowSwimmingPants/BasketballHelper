import UIKit

class StartingLineupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var startingLineup: NSMutableArray?
    var gameDatas: NSMutableArray?
    var period: Int?
    var delegate: SegmentBarViewController?
    @IBOutlet weak var tableView: UITableView!
//    let players = ["王小平", "蔡小甫", "李小銓", "陳小志", "黃老師"]
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startingLineup!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "startLinePlayerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let player = startingLineup?[indexPath.row] as! Page_playerList
//        let starting = startingLineup![index!] as! Page_playerList
        cell.textLabel?.text = player.name
        
        var didFind = false;
        for i in 0..<gameDatas!.count {
            let gameData = gameDatas![i] as! GameDataCount
            if gameData.playerID == player.playerID && gameData.Period == period!{
                cell.detailTextLabel?.text = "已有資料"
                didFind = true;
                break
            }
        }
        if !didFind {
            cell.detailTextLabel?.text = ""
        }

        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PlayerDataTableViewController {
//            let indexPath = sender as! IndexPath
            let index = tableView.indexPathForSelectedRow?.row
//            controller.delegate = self
            let starting = startingLineup![index!] as! Page_playerList
            controller.playerName = starting.name
            
            controller.gameDatas = gameDatas
            
//            目的：已經點選球員列表  要執行轉跳到修改該節資料頁面
//
//            細節：
//            ＊需傳過去球員該節ＧＡＭＥＤＡＴＡ
//                ·已有該球員該節ＧＡＭＥＤＡＴＡ直接傳送
//                ·沒有該球員該節ＧＡＭＥＤＡＴＡ建立後傳送
//
//            做法:
//            須先判斷有沒有球員該節ＧＡＭＥＤＡＴＡ
//            =>透過PlayerID&periodIndex
            
            var didFind = false;
            for i in 0..<gameDatas!.count {
                let gameData = gameDatas![i] as! GameDataCount
                let starting = startingLineup![index!] as! Page_playerList
                if gameData.playerID == starting.playerID && gameData.Period == period!{
                    controller.gameData = gameData
                    didFind = true;
                    break
                }
            }
            if !didFind {
                let starting = startingLineup![index!] as! Page_playerList
                let gameData = GameDataCount(period!, starting.playerID)
                gameDatas?.add(gameData)
                controller.gameData = gameData
            }
            
        }
    }
}
