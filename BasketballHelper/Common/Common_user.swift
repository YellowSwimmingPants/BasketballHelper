//
//  Common.swift
//  BasketballHelper
////  Created by 王克平 on 2019/3/19.
//  Copyright © 2019 李宜銓. All rights reserved.

import Foundation
import UIKit

let common_url_user = "http://127.0.0.1:8080/myBasketballHelper_Web/"
let common_url_playerInfo = "http://127.0.0.1:8080/myBasketballHelper_Web/"
func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

func showSimpleAlert(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(cancel)
    /* 呼叫present()才會跳出Alert Controller */
    viewController.present(alertController, animated: true, completion:nil)
}

func showSimpleActionSheet(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    viewController.present(alertController, animated: true, completion: nil)
}

func showToast(view: UIView, message : String) {
    let toast_width = CGFloat(150)
    let toast_height = CGFloat(35)
    let toast_x = (view.frame.width - toast_width) / 2
    let toast_y = (view.frame.height - toast_height) / 2
    let toastLabel = UILabel(frame: CGRect(x: toast_x, y: toast_y, width: toast_width, height: toast_height))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    view.addSubview(toastLabel)
    UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}

