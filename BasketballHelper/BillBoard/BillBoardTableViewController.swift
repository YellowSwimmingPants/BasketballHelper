//
//  BillBoardTableViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import Foundation

class BillBoardTableViewController: UITableViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    var billBoard: BillBoard!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    
    
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
