import UIKit

class SegmentBarViewController: UIViewController {
    var period: Int?
    var startingLineup: NSMutableArray?
//    var delegate: PeriodTableViewController?
    @IBOutlet weak var ChangePlayerView: UIView!
    @IBOutlet weak var StartingLineupView: UIView!
    var gameDatas: NSMutableArray?
    var getController: StartingLineupViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第" + String(period!) + "節"
    }
    
    @IBAction func SwitchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            StartingLineupView.alpha = 1
            ChangePlayerView.alpha = 0
//            var controller = storyboard?.instantiateViewController(withIdentifier: "starting") as! StartingLineupViewController
            getController!.tableView.reloadData()
        } else {
            StartingLineupView.alpha = 0
            ChangePlayerView.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? StartingLineupViewController {
            controller.startingLineup = startingLineup
                controller.gameDatas = gameDatas!
            controller.period = period
            getController = controller
        } else if let controller = segue.destination as? ChangePlayerViewController {
            controller.startingLineup = self.startingLineup
        }
    }
}
