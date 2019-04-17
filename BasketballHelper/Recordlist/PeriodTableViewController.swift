import UIKit

class PeriodTableViewController: UITableViewController {
    let url_server = URL(string: common_url_user + "GameServlet")
    var gameName: String?
    var gameDate: String?
    var startingLineup: NSMutableArray?
    var gameDatas = NSMutableArray()
    var period: Int?
    let userDefault = UserDefaults()
    var users: UserInfo!
    var userInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = gameName
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SegmentBarViewController {
            if segue.identifier == "PeriodOne" {
                period = 1
            } else if segue.identifier == "PeriodTwo" {
                period = 2
            } else if segue.identifier == "PeriodThree" {
                period = 3
            } else if segue.identifier == "PeriodFour" {
                period = 4
            } else if segue.identifier == "OverTime" {
                period = 5
            }
            controller.startingLineup = startingLineup
            controller.gameDatas = gameDatas
            controller.period = period
        }
    }
 
    @IBAction func clickSave(_ sender: Any) {
        if userDefault.data(forKey: "userDefault") != nil {
            let game = Game(0, gameName!, gameDate!)
            
            var requestParam = [String: Any]()
    //        requestParam["action"] = "gameInsert"
            requestParam["action"] = "gameAndGameDataInsert"
            requestParam["game"] = try! String(data: JSONEncoder().encode(game), encoding: .utf8)
            var gameDatasString = "["
            
            for i in 0..<gameDatas.count {
                if i > 0 {
                    gameDatasString +=  ",";
                }
                let gameDataString = try! String(data: JSONEncoder().encode(gameDatas[i] as! GameDataCount), encoding: .utf8)
                gameDatasString +=  gameDataString!;
            }
            gameDatasString += "]"
            requestParam["gameDatas"] = gameDatasString
            executeTask(self.url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    if count != 0 {
                                        // 新增成功要做啥寫這
                                        self.navigationController?.popToRootViewController(animated: true)
                                    } else {
                                        showSimpleAlert(message: "存檔失敗，請檢察網路連線", viewController: self)
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
            }
        } else {
            showToast(view: self.view, message: "請先註冊")
        }
    }
    
    
    

}
