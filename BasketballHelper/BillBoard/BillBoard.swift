//
//  BillBoard.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/19.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import Foundation

class BillBoard: Codable {
    var billBoardId: Int
    var date: Date?
    var title: String
    var content: String
    var type: String
    var teamInfo: String
    
    public init(_ billBoardId: Int, _ date: Date, _ title: String, _ content: String, _ type: String, _ teamInfo: String) {
        self.billBoardId = billBoardId
        self.date = date
        self.title = title
        self.content = content
        self.type = type
        self.teamInfo = teamInfo
    }
    
    var dateStr: String {
        if date != nil {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            return format.string(from: date!)
        } else {
            return ""
        }
    }
}
