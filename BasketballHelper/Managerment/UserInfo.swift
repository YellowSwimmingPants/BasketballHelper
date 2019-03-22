//
//  UserInfo.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/20.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import Foundation

class UserInfo: Codable {
    var userId: Int
    var userAccount: String
    var userPassword: String
    var userName: String
    var email: String
    var priority: Int
    
    public init(_ userId: Int, _ userAccount: String, _ userPassword: String, _ userName: String, _ email: String, _ priority: Int) {
        self.userId = userId
        self.userAccount = userAccount
        self.userPassword = userPassword
        self.userName = userName
        self.email = email
        self.priority = priority
    }
}
