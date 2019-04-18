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
        requestParam["playerID"] = dataSegue.playerID
        print(dataSegue.playerID)
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
        lbFT.text = String(describing: playdata!.FT!)
        lbFTL.text = String(describing: playdata!.FTL!)
        lbFG.text = String(describing: playdata!.FG!)
        lbFGL.text = String(describing:playdata!.FGL!)
        lbTPM.text = String(describing:playdata!.TPM!)
        lbTPL.text = String(describing:playdata!.TPL!)
        lbFOUL.text = String(describing:playdata!.Foul!)
        lbOfnReb.text = String(describing:playdata!.OfnReb!)
        lbDefReb.text = String(describing: playdata!.DefReb!)
        lbTurnOver.text = String(describing: playdata!.Assist!)
        lbSteal.text = String(describing: playdata!.Steal!)
        lbBlock.text = String(describing: playdata!.Block!)
        lbAssist.text = String(describing: playdata!.Assist!)
        let debugFtPercentage = String(format: "%.1f",((Double(playdata!.FT!) / (Double(playdata!.FT!+playdata!.FTL!))) * 100))
        if debugFtPercentage == "nan" {
            A1.text = "0"
        } else {
            A1.text = String(format: "%.1f",((Double(playdata!.FT!) / (Double(playdata!.FT!+playdata!.FTL!))) * 100))
        }
        
        let debugFgPercentage = String(format: "%.1f",((Double(playdata!.FG!) / (Double(playdata!.FG!+playdata!.FGL!))) * 100))
        if debugFgPercentage == "nan" {
            A2.text = "0"
        } else {
            A2.text = String(format: "%.1f",((Double(playdata!.FG!) / (Double(playdata!.FG!+playdata!.FGL!))) * 100))
        }
        
        let debugTpPercentage = String(format: "%.1f",((Double(playdata!.TPM!) / (Double(playdata!.TPM!+playdata!.TPL!))) * 100))
        if debugTpPercentage == "nan" {
            A3.text = "0"
        } else {
            A3.text = String(format: "%.1f",((Double(playdata!.TPM!) / (Double(playdata!.TPM!+playdata!.TPL!))) * 100))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "barchart" {
            let Detail = segue.destination as! PlayerBarChart
            Detail.chart = playdata
        }
    }
    
    
}

