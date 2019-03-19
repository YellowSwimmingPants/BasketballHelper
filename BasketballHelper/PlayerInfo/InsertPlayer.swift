//
//  InsertPlayer.swift
//  BasketballHelper
//
//  Created by 陳南宇 on 2019/3/18.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class InsertPlayer: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   let url_server = URL(string: common_url + "PlayerInsert")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfPosition: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tvResult: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func clickTackPicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    @IBAction func imagePicker(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let playerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            image = playerImage
//            imageView.image = playerImage
//        }
//        dismiss(animated: true, completion: nil)
//    }
    
    
    @IBAction func clickSave(_ sender: Any) {
        let name = tfName.text == nil ? "" :
            tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let nickname = tfNickName.text == nil ? "" :
            tfNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = tfPhone.text == nil ? "" :
            tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthday = tfBirthday.text == nil ? "" :
            tfBirthday.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let number = tfNumber.text == nil ? "" :
            tfNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let position = tfPosition.text == nil ? "" :
            tfPosition.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = tfEmail.text == nil ? "" :
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if name!.isEmpty{
            tvResult.text = "Name is nvalid"
            return
        }
        var requestParam = [String: String]()
        requestParam["name"] = name
        requestParam["nickname"] = nickname
        requestParam["phone"] = phone
        requestParam["birthday"] = birthday
        requestParam["number"] = number
        requestParam["position"] = position
        requestParam["email"] = email
        executeTask(url_server!, requestParam)
    }
    
    func executeTask(_ url_server: URL, _ requestParam: [String: String]){
        // 將輸出資料列印出來除錯用
        print("output: \(requestParam)")
        let jsonData = try! JSONEncoder().encode(requestParam)
        var request = URLRequest(url: url_server)
        request.httpMethod = "POST"
        // 不使用cache
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        // 請求參數為JSON data，無需再轉成JSON字串
        request.httpBody = jsonData//2
        let session = URLSession.shared//2
        // 建立連線並發出請求，取得結果後會呼叫closure執行後續處理
        
//        if self.image != nil {
//            request["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()//把image轉為base64字串
//        }
        
        let task = session.dataTask(with: request) { (data, response, error) in//傳送跟接收
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    // 將結果顯示在UI元件上必須轉給main thread
                    DispatchQueue.main.async {
                        self.showResult(data!)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func showResult(_ jsonData: Data) {
        if let result = try? JSONDecoder().decode([String: String].self, from: jsonData) {
            let user = result["KEY"]
            tvResult.text = user
        } else {
            self.tvResult.text = "get nothing"
        }
    }
    
    
    
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
