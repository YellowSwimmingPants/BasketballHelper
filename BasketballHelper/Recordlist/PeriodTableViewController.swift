import UIKit

class PeriodTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @IBAction func clickCancel(_ sender: Any) {
         let gameRecordTVC = self.storyboard?.instantiateViewController(withIdentifier: "gameRecordTVC") as! GameRecordTableViewController
        self.navigationController?.popToViewController(gameRecordTVC, animated: true)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        
    }
    
    

}
