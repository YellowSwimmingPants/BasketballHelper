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
    var months: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        months = ["罰球命中", "兩分命中", "三分命中", "犯規數", "進攻籃板", "防守籃板", "失誤", "抄截", "火鍋", "助攻"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 4.0, 10.0, 3.0]
        
        setChar(dataPoints: months, values: unitsSold)
       
    }
    
    func setChar(dataPoints: [String], values: [Double]){
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: values[i], y: counter)
            dataEntries.append(dataEntry)
    }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "units Sold")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
//        chartDataSet.colors = ChartColorTemplates.colorful()
    }
}
