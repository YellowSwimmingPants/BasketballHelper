import UIKit

class PeriodFromDBTableViewController: UITableViewController {
//    let url_server = URL(string: common_url_user + "GameServlet")
//    var gameDatas = [GameDataCount]()
    var gameName: String?
    var period: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = gameName
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PlayersEachPeriodTableViewController {
            if segue.identifier == "PeriodOne" {
                period = 1
            } else if segue.identifier == "PeriodTwo" {
                period = 2
            } else if segue.identifier == "PeriodThree" {
                period = 3
            } else if segue.identifier == "PeriodFour" {
                period = 4
            } else if segue.identifier == "OverTime" {
                period = 5
            }
            controller.period = period
        }
    }
    

}
