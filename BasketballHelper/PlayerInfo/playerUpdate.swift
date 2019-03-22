//
//  PlayerUpdate.swift
//  BasketballHelper
//
//  Created by 陳南宇 on 2019/3/21.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class PlayerUpdate: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let url_server = URL(string: common_url + "PlayerUpdate")
    var image: UIImage?
    
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
        
        // Do any additional setup after loading the view.
    }
    @IBAction func clickTakePicture(_ sender: Any) {
        imagePicker(type: .camera)
        
    }
    
    @IBAction func clickPickPicture(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let playerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = playerImage
            imageView.image = playerImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickSave(_ sender: Any) {let name = tfName.text == nil ? "" :
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
        if self.image != nil {
            requestParam["photo"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()//把image轉為base64字串
        }
        executeTask(url_server!, requestParam)
        
    }
    
    func executeTask(_ url_server: URL, _ requestParam: [String: String]){
        
    }
    
    
}
