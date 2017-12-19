//
//  PostViewController.swift
//  Anonygram
//
//  Created by Daniel Jones on 13/12/2017.
//  Copyright © 2017 Daniel Jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var imageFileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage) {
        let randomName = randomStringWithLength(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let uploadRef = Storage.storage().reference().child("images/\(randomName).jpg")
        let uploadTask = uploadRef.putData(imageData!, metadata: nil) { metadata,
            error in
            if error == nil {
                //success
                print("success")
                self.imageFileName = "\(randomName as String).jpg"
            } else {
                //error
                print("error uploading")
            }
        }
    }
    
    func randomStringWithLength(length: Int) -> NSString {
        let characters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: length)
        
        for i in 0..<length {
            var len = UInt32(characters.length)
            var rand = arc4random_uniform(len)
            randomString.appendFormat("%C", characters.character(at: Int(rand)))
        }
        return randomString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // will run if the user hits cancel
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // will run when the user finishes picking an image from the library
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = pickedImage
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func postTapped(_ sender: UIButton) {
        
        if (self.imageFileName != "") {
            if let uid = Auth.auth().currentUser?.uid {
                
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    if let userDictionary = snapshot.value as? [String: AnyObject] {
                        for user in userDictionary {
                            if let username = user.value as? String {
                                if let title = self.titleTextField.text {
                                    if let location = self.locationTextField.text {
                                        if let content = self.contentTextView.text {
                                            let postObject: Dictionary<String, Any> = [
                                                "uid" : uid,
                                                "title" : title,
                                                "location" : location,
                                                "content" : content,
                                                "username" : username,
                                                "image" : self.imageFileName
                                            ]
                                            
                                            Database.database().reference().child("posts").childByAutoId().setValue(postObject)
                                            
                                            let alert = UIAlertController(title: "Success!", message: "Your post was added successfully.", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                //code will run when ok button is pressed
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                                                self.present(vc!, animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
            }
        } else {
            //image hasnt finished uploading
            let alert = UIAlertController(title: "Please wait", message: "Your image has not finished uploading yet, please wait...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
