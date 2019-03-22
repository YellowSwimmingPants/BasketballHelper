//
//  ScanQRViewController.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // 預覽時管理擷取影像的物件
    var captureSession: AVCaptureSession!
    // 預覽畫面
    var previewLayer: AVCaptureVideoPreviewLayer!
    // 偵測到QR code時需要加框
    var qrFrameView: UIView!
    // 當user決定加好友時呼叫
    var completionHandler:((String) -> Void)?
    let url_server = URL(string: common_url + "UserInfoServlet")
    let userDefault = UserDefaults()
    var userInfos = [UserInfo]()
    var users: UserInfo!
    var viewController = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInfo = userDefault.data(forKey: "userDefault") {
            users = try! JSONDecoder().decode(UserInfo.self, from: userInfo)
        }
        startPreviewAndScanQR()
    }
    
    func startPreviewAndScanQR() {
        // 管理影像擷取期間的輸入與輸出
        captureSession = AVCaptureSession()
        // 負責擷取影像的預設裝置
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        // 建立輸入物件
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        if (captureSession.canAddInput(input)) {
            // 設定擷取期間的輸入
            captureSession.addInput(input)
        } else {
            showSimpleAlert(message: "請開啟相機功能", viewController: self)
            captureSession = nil
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            // 設定擷取期間的輸出
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // 欲處理的類型為QR code
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showSimpleAlert(message: "請開啟相機功能", viewController: self)
            captureSession = nil
            return
        }
        
        // 建立擷取期間所需顯示的預覽圖層
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        createQRFrame()
        preview(true)
    }
    
    // 建立QR code掃描框
    func createQRFrame() {
        qrFrameView = UIView()
        qrFrameView.layer.borderColor = UIColor.yellow.cgColor
        qrFrameView.layer.borderWidth = 3
        view.addSubview(qrFrameView)
        view.bringSubviewToFront(qrFrameView)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 將取得的資訊轉成條碼資訊
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let qrString = metadataObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            scanSuccess(qrCode: qrString)
            if let barCodeObject = previewLayer.transformedMetadataObject(for: metadataObject) {
                // 成功解析就將QR code圖片框起來
                qrFrameView.frame = barCodeObject.bounds
            }
        } else {
            // 無法轉成條碼資訊就將圖框隱藏
            qrFrameView.frame = CGRect.zero
        }
    }
    
    func scanSuccess(qrCode: String) {
        print(qrCode)
        // 停止預覽
        preview(false)
        joinTeam(name: qrCode)
    }
    
    func joinTeam(name: String) {
        let alert = UIAlertController(title: "是否加入\(name)?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            var requestParam = [String: Any]()
            requestParam["action"] = "join"
            requestParam["userAccount"] = self.users.userAccount
            requestParam["teamName"] = name
            executeTask(self.url_server!, requestParam, completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let result = try? JSONDecoder().decode([String: String].self, from: data!)
                        let count = result!["count"]
                        DispatchQueue.main.async {
                            if count != "0" {
                                let teamInfo = try! JSONEncoder().encode(name)
                                self.userDefault.set(teamInfo, forKey: "teamInfo")
                                self.userDefault.synchronize()
                                self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Homepage")
                                self.present(self.viewController, animated: true, completion: nil)
                            } else {
                                showToast(view: self.view, message: "加入失敗")
                                self.viewController = self.storyboard!.instantiateViewController(withIdentifier: "Sign")
                                self.present(self.viewController, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }))
    }

    // 是否開啟預覽畫面
    func preview(_ yes: Bool) {
        if yes {
            // 讓QR code掃描框消失 (避免前一次QR code掃描框留在畫面上)
            qrFrameView.frame = CGRect.zero
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        } else {
            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
        }
        preview(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .all
        }
        preview(false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
