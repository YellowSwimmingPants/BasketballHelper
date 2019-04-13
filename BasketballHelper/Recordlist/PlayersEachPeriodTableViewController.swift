import UIKit

class PlayersEachPeriodTableViewController: UITableViewController {
    var period: Int!
    var players: [Page_playerList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第" + String(period) + "節"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (players?.count)!
    }
}
