
import UIKit

class PlayerInformation: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNickName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbBirthday: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbPosition: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    let url_server = URL(string: common_url_playerInfo + "PlayerServlet")
    
    var playerInformation : Page_playerList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title? = playerInformation.name!
        showplayer()
//        print("3+\(playerInformation)")
    }
    func showplayer(){
        lbName.text = playerInformation.name!
        lbNickName.text = playerInformation.nickname!
        lbPhone.text = playerInformation.phone!
        lbBirthday.text = playerInformation.birthday!
        lbNumber.text = playerInformation.number!
        lbPosition.text = playerInformation.position!
        lbEmail.text = playerInformation.email!
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = playerInformation.id
        // 圖片寬度 = 螢幕寬度的
        requestParam["imageSize"] = view.frame.width
        executeTask(url_server!, requestParam) { (data, response, error) in
            var image: UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }
            if image == nil {
                image = UIImage(named: "noImage.jpg")
            }
            DispatchQueue.main.async { self.imageView.image = image }
        }

    }
    

   

}
