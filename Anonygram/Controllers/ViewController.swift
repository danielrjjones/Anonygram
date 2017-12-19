//
//  ViewController.swift
//  Anonygram
//
//  Created by Daniel Jones on 13/12/2017.
//  Copyright © 2017 Daniel Jones. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //is the user already logged into the app?
        if Auth.auth().currentUser != nil {
            // if there is a user session already
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
            self.present(vc!, animated: true, completion: nil)
        }
        
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: username!, password: password!) { (user, error) in
            if error != nil {
                //error loggin user in
                let alert = UIAlertController(title: "Error", message: "Incorrect Username/Passsword", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                //success
                //let alert = UIAlertController(title: "Success", message: "Successfully logged in...", preferredStyle: .alert)
                //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //self.present(alert, animated: true, completion: nil)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                self.present(vc!, animated: true, completion: nil)
                
            }
        }
        
    }
    
}

