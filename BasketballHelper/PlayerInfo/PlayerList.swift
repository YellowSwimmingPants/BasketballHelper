//
//  PlayerList.swift
//  BasketballHelper
//
//  Created by 陳南宇 on 2019/3/19.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class PlayerList: UITableViewController {
    let url_server = URL(string: common_url + "PlayerList")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
    }
    
      /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")//attributedTitle標題屬性
        refreshControl.addTarget(self, action: #selector(showAllSpots), for: .valueChanged)
        //addTarget 指下拉動作做觸發
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllSpots()
    }
    
    @objc func showAllSpots(){
        
    }



}
