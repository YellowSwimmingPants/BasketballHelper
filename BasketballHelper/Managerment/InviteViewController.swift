//
//  InviteViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

//    let url_server = URL(string: common_url + "TeamInfoServlet")
    let userDefault = UserDefaults()
//    var userInfos = [UserInfo]()
//    var users: UserInfo!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let teamInfo = userDefault.data(forKey: "teamInfo") {
//            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            ciFilter.setValue(teamInfo, forKey: "inputMessage")
            guard let ciImage_smallQR = ciFilter.outputImage else { return }
            // QR code圖片很小，需要放大
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
            let qrCodeImage = UIImage(ciImage: ciImage_largeQR)
            qrCodeImageView.image = qrCodeImage
        } else {
            showToast(view: self.view, message: "沒有找到QRCode")
        }
        
//        showQRCode()
    }
    
//    func showQRCode() {
//        var requestParam = [String: Any]()
//        requestParam["action"] = "getQRCode"
//        requestParam["userAccount"] = users.userAccount
//        var image: UIImage?
//        executeTask(url_server!, requestParam) { (data, response, error) in
//            if error == nil {
//                if data != nil {
//                    image = UIImage(data: data!)
//                }
//                if image == nil {
//                    image = UIImage(named: "noImage.jpg")
//                }
//                DispatchQueue.main.async {
//                    self.qrCodeImageView.image = image
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }
    
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
