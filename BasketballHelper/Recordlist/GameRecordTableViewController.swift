import UIKit

class GameRecordTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let url_server = URL(string: common_url + "GameServlet")
    var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        games.append(Game("name", "date"))
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "gameCell"
        
        /*如果捲動表格，表格一邊會增加一列儲存格，另一邊則會消失一列儲存格，消失的儲存格其實是被移出佇列(dequeue)，如果能重複使用消失儲存格，就能節省記憶體空間；而且可避免建立與釋放儲存格空間的動作，可以提升效能 */
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        
        let game = games[indexPath.row]
        cell.textLabel?.text = game.gameName
        cell.detailTextLabel?.text = game.gameDate
        
        return cell
    }
    
}
