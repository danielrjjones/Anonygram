//
//  RegisterViewController.swift
//  Anonygram
//
//  Created by Daniel Jones on 13/12/2017.
//  Copyright © 2017 Daniel Jones. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        
        let username = usernameField.text
        let email = emailField.text
        let password = passwordTextField.text
     
        Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
            if error != nil {
                //error creating account
                let alert = UIAlertController(title: "Error", message: "An error occurred when creating your account, please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                //account created
                
                if let uid = Auth.auth().currentUser?.uid {
                    let userRef =
                        Database.database().reference().child("users").child(uid)
                    let object = ["username":username]
                    userRef.setValue(object)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                    self.present(vc!, animated: true, completion: nil)
                }
                
                //let alert = UIAlertController(title: "Success!", message: "Account has been created...", preferredStyle: .alert)
                //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    

}
