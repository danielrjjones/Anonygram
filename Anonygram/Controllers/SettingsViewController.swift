//
//  SettingsViewController.swift
//  Anonygram
//
//  Created by Daniel Jones on 15/12/2017.
//  Copyright © 2017 Daniel Jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutTapped(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.present(vc!, animated: true, completion: nil)
        }
        catch {
            print("Error, there was a problem signing out.")
        }
        
    }
    
}
