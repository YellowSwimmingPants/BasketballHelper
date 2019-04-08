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
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrFrameView: UIView!
    var completionHandler:((String) -> Void)?
    let url_server = URL(string: common_url_user + "ManagersServlet")
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
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        if (captureSession.canAddInput(input)) {
            captureSession.addInput(input)
        } else {
            showSimpleAlert(message: "請開啟相機功能", viewController: self)
            captureSession = nil
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showSimpleAlert(message: "請開啟相機功能", viewController: self)
            captureSession = nil
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        createQRFrame()
        preview(true)
    }
    
    func createQRFrame() {
        qrFrameView = UIView()
        qrFrameView.layer.borderColor = UIColor.yellow.cgColor
        qrFrameView.layer.borderWidth = 3
        view.addSubview(qrFrameView)
        view.bringSubviewToFront(qrFrameView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let qrString = metadataObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            scanSuccess(qrCode: qrString)
            if let barCodeObject = previewLayer.transformedMetadataObject(for: metadataObject) {
                qrFrameView.frame = barCodeObject.bounds
            }
        } else {
            qrFrameView.frame = CGRect.zero
        }
    }
    
    func scanSuccess(qrCode: String) {
        print(qrCode)
        preview(false)
        joinTeam(name: qrCode)
    }
    
    func joinTeam(name: String) {
        let alert = UIAlertController(title: "是否加入\(name)?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            var requestParam = [String: Any]()
            requestParam["action"] = "joinTeam"
            requestParam["userAccount"] = self.users.userAccount
            requestParam["userPassword"] = self.users.userPassword
            requestParam["teamInfo"] = name
            executeTask(self.url_server!, requestParam, completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let result = try? JSONDecoder().decode([String: String].self, from: data!)
                        DispatchQueue.main.async {
                            if result!["success"] == "Yes" {
                                let userInfo = result!["userInfo"]
                                let login = try? JSONDecoder().decode(UserInfo.self, from: userInfo!.data(using: .utf8)!)
                                let loginOK = try! JSONEncoder().encode(login)
                                self.userDefault.set(loginOK, forKey: "userDefault")
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.preview(true)
        }))
        present(alert, animated: true)
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
