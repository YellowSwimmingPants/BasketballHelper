//
//  TeamInfo.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import Foundation

class TeamInfo: Codable {
    var id: Int
    var teamName: String
    
    public init(_ id: Int, _ teamName: String) {
        self.id = id
        self.teamName = teamName
    }
}
