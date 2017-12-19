//
//  PostTableViewCell.swift
//  Anonygram
//
//  Created by Daniel Jones on 14/12/2017.
//  Copyright © 2017 Daniel Jones. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.titleLabel.alpha = 0
        self.usernameLabel.alpha = 0
        self.postImageView.alpha = 0
        self.contentTextView.alpha = 0
        self.locationLabel.alpha = 0
        
        //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        //self.profileImageView.clipsToBounds = true;
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
