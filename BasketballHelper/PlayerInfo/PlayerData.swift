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
        playdata = try? JSONDecoder().decode(GameDataCount.self, from: data)
        //        print(String(describing: playdata!.Assist!))
        lbFT.text = String(format: "%.0f", playdata!.FT!)
        lbFTL.text = String(format: "%.0f", playdata!.FTL!)
        lbFG.text = String(format: "%.0f", playdata!.FG!)
        lbFGL.text = String(format: "%.0f",playdata!.FGL!)
        lbTPM.text = String(format: "%.0f",playdata!.TPM!)
        lbTPL.text = String(format: "%.0f",playdata!.TPL!)
        lbFOUL.text = String(format: "%.0f",playdata!.Foul!)
        lbOfnReb.text = String(format: "%.0f",playdata!.OfnReb!)
        lbDefReb.text = String(format: "%.0f", playdata!.DefReb!)
        lbTurnOver.text = String(format: "%.0f", playdata!.Assist!)
        lbSteal.text = String(format: "%.0f", playdata!.Steal!)
        lbBlock.text = String(format: "%.0f", playdata!.Block!)
        lbAssist.text = String(format: "%.0f", playdata!.Assist!)
        //A1 = 罰球總平均
        A1.text = String(format: "%.1f",(playdata!.FT!/(playdata!.FT!+playdata!.FTL!))*(hundred))
        //A2 = 兩分總平均
        A2.text = String(format: "%.1f",(playdata!.FG!/(playdata!.FG!+playdata!.FGL!))*(hundred))
        //A3 = 三分總平均
        A3.text = String(format: "%.1f",(playdata!.TPM!/(playdata!.TPM!+playdata!.TPL!))*(hundred))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "barchart" {
            let Detail = segue.destination as! PlayerBarChart
            Detail.chart = playdata
        }
    }
    
    
}

