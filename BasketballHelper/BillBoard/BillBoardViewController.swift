//
//  BillBoardViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class BillBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var billBoardTableView: UITableView!
    
    let now = Date()
    var callendar = Calendar.current
    let dateFmatter = DateFormatter()
    var components = DateComponents()
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var userInfo = [UserInfo]()
    var users: UserInfo!
    var billBoards = [BillBoard]()
    let url_server = URL(string: common_url_user + "BillBoardServlet")
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userInfo = userDefault.data(forKey: "userDefault")
        if (userInfo != nil) {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo!)
            showBillBoard(teamInfo: users.teamInfo)
            callendar.locale = Locale(identifier: "zh")
            dateFmatter.locale = Locale(identifier: "zh_TW")
            dateFmatter.dateFormat = "yyyy年M月"
            components.year = callendar.component(.year, from: now)
            components.month = callendar.component(.month, from: now)
            components.day = 1
            calculation()
            createGesture()
        } else {
            callendar.locale = Locale(identifier: "zh")
            dateFmatter.locale = Locale(identifier: "zh_TW")
            dateFmatter.dateFormat = "yyyy年M月"
            components.year = callendar.component(.year, from: now)
            components.month = callendar.component(.month, from: now)
            components.day = 1
            calculation()
            createGesture()
        }
    }
    
    func showBillBoard(teamInfo: String) {
        var requestParam = [String: Any]()
        requestParam["action"] = "getBillBoard"
        requestParam["teamInfo"] = teamInfo
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(format)
            if error == nil {
                if data != nil {
                    if let result = try? decoder.decode([BillBoard].self, from: data!) {
                        self.billBoards = result
                        DispatchQueue.main.async {
                            self.billBoardTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func calculation() {
        let firstDayOfMonth = callendar.date(from: components)
        dateLabel.text = dateFmatter.string(from: firstDayOfMonth!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        }
        return 37
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let firstDayOfMonth = callendar.date(from: components)
        let firstWeekday = callendar.component(.weekday, from: firstDayOfMonth!)
        let weekdayAdding = 2 - firstWeekday
        let label = UILabel()
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        if (indexPath.row % 7 == 0) {
            cell.backgroundColor = UIColor.red
        } else if (indexPath.row % 7 == 6) {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }

        let daysCountInMonth = callendar.range(of: .day, in: .month, for: firstDayOfMonth!)?.count
        if indexPath.section == 0 {
            label.text = weekArray[indexPath.row]
            label.textColor = UIColor.black
            label.sizeToFit()
            label.center = cell.contentView.center
            cell.contentView.addSubview(label)
        }
        else if (indexPath.row + weekdayAdding) >= 1 && (indexPath.row + weekdayAdding) <= daysCountInMonth! {
            label.textColor = UIColor.black
            label.text = "\(indexPath.row + weekdayAdding)"
            label.sizeToFit()
            label.center = cell.contentView.center
            cell.contentView.addSubview(label)
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize: CGFloat = myBoundSize / 7.5
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @IBAction func clickPrev(_ sender: Any) {
        components.month = components.month! - 1
        calculation()
        calendarCollectionView.reloadData()
    }
    
    @IBAction func clickNext(_ sender: Any) {
        components.month = components.month! + 1
        calculation()
        calendarCollectionView.reloadData()
    }
    
    func createGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(clickPrev(_:)))
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = .right
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(clickNext(_:)))
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = .left
        view.addGestureRecognizer(swipeRight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billBoards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "billBoardCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        let billBoard = billBoards[indexPath.row]
        
        cell.textLabel?.text = billBoard.dateStr
        cell.detailTextLabel?.text = billBoard.title
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billBoardDetail" {
            let indexPath = self.billBoardTableView.indexPath(for: sender as! UITableViewCell)
            let billBoard = billBoards[indexPath!.row]
            let billBoardTableViewController = segue.destination as! BillBoardTableViewController
            billBoardTableViewController.billBoard = billBoard
        }
    }
}
