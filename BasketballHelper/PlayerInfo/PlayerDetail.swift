

import UIKit


class PlayerDetail: UIViewController {
    @IBOutlet weak var plyaerDetail: UIView!
    @IBOutlet weak var playerData: UIView!
    var playerList : Page_playerList!
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            plyaerDetail.alpha = 1
            playerData.alpha = 0
        }else{
            plyaerDetail.alpha = 0
            playerData.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "information"{
            let Detail = segue.destination as! PlayerInformation
            Detail.playerInformation = playerList
            
        }
        
    }
    
    
}
