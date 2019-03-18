

import UIKit

class PlayerDetail: UIViewController {
    @IBOutlet weak var PlayerDetail: UIView!
    @IBOutlet weak var PlayerData: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            PlayerDetail.alpha = 1
            PlayerData.alpha = 0
        }else{
            PlayerDetail.alpha = 0
            PlayerData.alpha = 1
        }
    }
    
}
