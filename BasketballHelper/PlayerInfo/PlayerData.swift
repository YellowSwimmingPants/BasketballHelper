//
//  PlayerData.swift
//  BasketballHelper
//
//  Created by 陳南宇 on 2019/3/29.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import Charts

class PlayerData: UIViewController {
    @IBOutlet weak var lbFT: UILabel!
    @IBOutlet weak var lbFTL: UILabel!
    @IBOutlet weak var lbFG: UILabel!
    @IBOutlet weak var lbFGL: UILabel!
    @IBOutlet weak var lbTPM: UILabel!
    @IBOutlet weak var lbTPL: UILabel!
    @IBOutlet weak var lbFOUL: UILabel!
    @IBOutlet weak var lbOfnReb: UILabel!
    @IBOutlet weak var lbDefReb: UILabel!
    @IBOutlet weak var lbTurnOver: UILabel!
    @IBOutlet weak var lbSteal: UILabel!
    @IBOutlet weak var lbBlock: UILabel!
    @IBOutlet weak var lbAssist: UILabel!
    @IBOutlet weak var A1: UILabel!
    @IBOutlet weak var A2: UILabel!
    @IBOutlet weak var A3: UILabel!
    
    var hundred:Double=100
    
    
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    var dataSegue : Page_playerList!
    var playdata : GameDataCount!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    
    @objc func showData(){
        var requestParam = [String : Any]()
        requestParam["action"] = "getData"
        requestParam["id"] = dataSegue.name!
        print(dataSegue.name!)
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
        let playdata = try? JSONDecoder().decode(GameDataCount.self, from: data)
//        print(String(describing: playdata!.Assist!))
        lbFT.text = String(describing: playdata!.FT!)
        lbFTL.text = String(describing: playdata!.FTL!)
        lbFG.text = String(describing: playdata!.FG!)
        lbFGL.text = String(describing: playdata!.FGL!)
        lbTPM.text = String(describing: playdata!.TPM!)
        lbTPL.text = String(describing: playdata!.TPL!)
        lbFOUL.text = String(describing: playdata!.Foul!)
        lbOfnReb.text = String(describing: playdata!.OfnReb!)
        lbDefReb.text = String(describing: playdata!.DefReb!)
        lbTurnOver.text = String(describing: playdata!.Assist!)
        lbSteal.text = String(describing: playdata!.Steal!)
        lbBlock.text = String(describing: playdata!.Block!)
        lbAssist.text = String(describing: playdata!.Assist!)
        //A1 = 罰球總平均
        A1.text = String(describing: (playdata!.FT!/playdata!.FTL!*(hundred)))
        //A2 = 兩分總平均
        A2.text = String(describing: (playdata!.FG!/playdata!.FGL!*(hundred)))
        //A3 = 三分總平均
        A3.text = String(describing: (playdata!.TPM!/playdata!.TPL!*(hundred)))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "barchart" {
            let Detail = segue.destination as! PlayerBarChart
            Detail.playdatabarchart = playdata
        }
    }
 
    
}

