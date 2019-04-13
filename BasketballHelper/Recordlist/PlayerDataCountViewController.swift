import UIKit

class PlayerDataCountViewController: UIViewController {
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var ft: UILabel!
    @IBOutlet weak var ftl: UILabel!
    @IBOutlet weak var ftPercentage: UILabel!
    @IBOutlet weak var fg: UILabel!
    @IBOutlet weak var fgl: UILabel!
    @IBOutlet weak var fgPecentage: UILabel!
    @IBOutlet weak var tpm: UILabel!
    @IBOutlet weak var tpl: UILabel!
    @IBOutlet weak var tpPercentage: UILabel!
    @IBOutlet weak var assist: UILabel!
    @IBOutlet weak var steal: UILabel!
    @IBOutlet weak var block: UILabel!
    @IBOutlet weak var ofnReb: UILabel!
    @IBOutlet weak var defReb: UILabel!
    @IBOutlet weak var foul: UILabel!
    @IBOutlet weak var turnOver: UILabel!
    
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    var player : Page_playerList!
    var playerData : GameDataCount!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    
    @objc func showData(){
        var requestParam = [String : Any]()
        requestParam["action"] = "getData"
        requestParam["playerID"] = player.playerID
        print(player.playerID)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    DispatchQueue.main.async {
                        self.dataShow(data!)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func dataShow(_ data: Data) {
        playerData = try? JSONDecoder().decode(GameDataCount.self, from: data)
        //        print(String(describing: playdata!.Assist!))
        ft.text = String(describing: playerData!.FT!)
        ftl.text = String(describing: playerData!.FTL!)
        fg.text = String(describing: playerData!.FG!)
        fgl.text = String(describing:playerData!.FGL!)
        tpm.text = String(describing:playerData!.TPM!)
        tpl.text = String(describing:playerData!.TPL!)
        foul.text = String(describing:playerData!.Foul!)
        ofnReb.text = String(describing:playerData!.OfnReb!)
        defReb.text = String(describing: playerData!.DefReb!)
        turnOver.text = String(describing: playerData!.Assist!)
        steal.text = String(describing: playerData!.Steal!)
        block.text = String(describing: playerData!.Block!)
        assist.text = String(describing: playerData!.Assist!)
        
        ftPercentage.text = String(format: "%.1f",((Double(playerData!.FT!) / (Double(playerData!.FT!+playerData!.FTL!))) * 100))
        
        fgPecentage.text = String(format: "%.1f",((Double(playerData!.FG!) / (Double(playerData!.FG!+playerData!.FGL!))) * 100))
        
        tpPercentage.text = String(format: "%.1f",((Double(playerData!.TPM!) / (Double(playerData!.TPM!+playerData!.TPL!))) * 100))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
