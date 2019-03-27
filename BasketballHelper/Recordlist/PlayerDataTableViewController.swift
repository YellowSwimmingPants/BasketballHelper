//
//  PlayerDataTableViewController.swift
//  BasketballHelper
//
//  Created by 李宜銓 on 2019/3/15.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

var actions = [Action]()

class PlayerDataTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actions.append(Action("罰球進球", 0))
        actions.append(Action("罰球不進", 0))
        actions.append(Action("2分進球", 0))
        actions.append(Action("2分不進", 0))
        actions.append(Action("3分進球", 0))
        actions.append(Action("3分不進", 0))
        actions.append(Action("犯規", 0))
        actions.append(Action("進攻籃板", 0))
        actions.append(Action("防守籃板", 0))
        actions.append(Action("失誤", 0))
        actions.append(Action("抄截", 0))
        actions.append(Action("助攻", 0))
        actions.append(Action("阻攻", 0))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "actionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ActionTableViewCell
        cell.lbActionName.text = actions[indexPath.row].actionName
        
        cell.tag = indexPath.row
        
//        cell.textLabel?.text = action
        return cell
    }
    
    @IBAction func clickMinus(_ sender: UIButton) {
        let n = sender.superview?.superview?.tag
        print(sender.superview?.superview?.tag)
        actions[n!].actionCount += 1
        let tableViewCell = sender.superview?.superview as! ActionTableViewCell
        tableViewCell.lbActionCount.text = String(actions[n!].actionCount)
        
//        if n == 0{
//            actions[n!].actionCount += 1
//            print(actions[n!].actionCount)
//
//
//        }else if n == 2{
//
//        }else if n == 3{
//
//        }else if n == 4{
//
//        }else if n == 5{
//
//        }else if n == 6{
//
//        }else if n == 7{
//
//        }
        
    }
    
    @IBAction func clickPlus(_ sender: UIButton) {
//        print(sender.superview?.superview?.tag)
        if sender.superview?.superview?.tag == 0{
           
        }else if sender.superview?.superview?.tag == 1{
            
        }else if sender.superview?.superview?.tag == 2{
            
        }else if sender.superview?.superview?.tag == 3{
            
        }else if sender.superview?.superview?.tag == 4{
            
        }else if sender.superview?.superview?.tag == 5{
            
        }else if sender.superview?.superview?.tag == 6{
            
        }else if sender.superview?.superview?.tag == 7{
            
        }
    }
    
    @IBAction func clickSave(_ sender: Any) {
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
