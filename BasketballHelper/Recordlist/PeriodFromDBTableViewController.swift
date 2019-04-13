import UIKit

class PeriodFromDBTableViewController: UITableViewController {
    let url_server = URL(string: common_url_user + "GameServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

}
