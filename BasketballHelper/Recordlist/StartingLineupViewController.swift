import UIKit

class StartingLineupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let players = ["王小平", "蔡小甫", "李小銓", "陳小志", "黃老師"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "startLinePlayerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let player = players[indexPath.row]
        cell.textLabel?.text = player
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
