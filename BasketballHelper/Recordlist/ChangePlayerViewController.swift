import UIKit

class ChangePlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var players = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "changePlayerCellID"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let player = players[indexPath.row]
        cell.textLabel?.text = player
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
