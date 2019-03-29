import UIKit

class SegmentBarViewController: UIViewController {

    @IBOutlet weak var StartingLineupView: UIView!
    @IBOutlet weak var ChangePlayerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SwitchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            StartingLineupView.alpha = 1
            ChangePlayerView.alpha = 0
        }else{
            StartingLineupView.alpha = 0
            ChangePlayerView.alpha = 1
        }
    }
    //hhh
    
}
