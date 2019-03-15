//
//  GameRecordTableViewController.swift
//  BasketballHelper
//
//  Created by 李宜銓 on 2019/3/12.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class GameRecordTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var games = [Game]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = userDefaults.string(forKey: "gameName") ?? ""
        let date = userDefaults.string(forKey: "dateString") ?? ""
        games.append(Game(gameName: name, gameDate: date))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "gameCell"
        
        /*如果捲動表格，表格一邊會增加一列儲存格，另一邊則會消失一列儲存格，消失的儲存格其實是被移出佇列(dequeue)，如果能重複使用消失儲存格，就能節省記憶體空間；而且可避免建立與釋放儲存格空間的動作，可以提升效能 */
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        
        let game = games[indexPath.row]
        /*  UITableViewCell本身有textLabel, detailTextLabel, imageView屬性可以設定主標、副標文字與圖片 */
        cell.textLabel?.text = game.gameName
        cell.detailTextLabel?.text = game.gameDate
        
        return cell
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
