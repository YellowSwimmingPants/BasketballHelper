//
//  PlayerBarChart.swift
//  BasketballHelper
//
//  Created by 陳南宇 on 2019/4/8.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import Charts
class PlayerBarChart: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    var item: [String]!
    var axisFormatDelgate: IAxisValueFormatter?
    var playdata : GameDataCount!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = ["罰球命中", "兩分命中", "三分命中", "犯規數", "進攻籃板", "防守籃板", "失誤", "抄截", " 火鍋", "助攻"]
        let playerdata: [Double] = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 4.0, 10.0, 3.0]
        setChar(dataPoints: item, values: playerdata)
       
    }
    
    func setChar(dataPoints: [String], values: [Double]){
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x:Double(i),  y:values[i])
            dataEntries.append(dataEntry)
    }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "球員統計圖表")
        let charData = BarChartData(dataSet: chartDataSet)
        barChartView.data = charData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.xAxis.granularity = 1
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.backgroundColor = UIColor(red: 189/255, green: 255/255, blue: 255/255, alpha: 1)
    }
}
