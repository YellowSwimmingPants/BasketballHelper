//
//  BillBoard.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/19.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import Foundation

class BillBoard: Codable {
    var id: Int
    var date: Date?
    var title: String
    var content: String
    var type: String
    
    public init(_ id: Int, _ date: Date, _ title: String, _ content: String, _ type: String) {
        self.id = id
        self.date = date
        self.title = title
        self.content = content
        self.type = type
    }
    
    var dateStr: String {
        if date != nil {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return format.string(from: date!)
        } else {
            return ""
        }
    }
}
