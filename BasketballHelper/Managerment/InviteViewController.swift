//
//  InviteViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    let userDefault = UserDefaults()
    var userInfos = [UserInfo]()
    var users: UserInfo!
    var viewController = UIViewController()
    
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
            let data = users.teamInfo.data(using: String.Encoding.ascii)
            guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            ciFilter.setValue(data, forKey: "inputMessage")
            guard let ciImage_smallQR = ciFilter.outputImage else { return }
            // QR code圖片很小，需要放大
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
            let qrCodeImage = UIImage(ciImage: ciImage_largeQR)
            qrCodeImageView.image = qrCodeImage
        } else {
            registerView.isHidden = false
        }
    }
    
    @IBAction func clickRegister(_ sender: Any) {
        viewController = storyboard!.instantiateViewController(withIdentifier: "Register")
        present(viewController, animated: true, completion: nil)
    }
}
