//
//  MainViewController.swift
//  Anonygram
//
//  Created by Daniel Jones on 14/12/2017.
//  Copyright © 2017 Daniel Jones. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsTableView: UITableView!
    
    var posts = NSMutableArray()
    var refresher: UIRefreshControl!
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        loadData()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refresher.addTarget(self, action: #selector(MainViewController.refreshPage), for: UIControlEvents.valueChanged)
        postsTableView.addSubview(refresher)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func moreTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sorry!", message: "This action hasn't been created yet. Please be patient!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.posts.add(post.value)
                }
                self.postsTableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell

        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        
        cell.usernameLabel.text = post["username"] as? String
        cell.contentTextView.text = post["content"] as! String
        cell.locationLabel.text = post["location"] as? String
        
        if let imageName = post["image"] as? String {
            let imageRef = Storage.storage().reference().child("images/\(imageName)")
            imageRef.getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                if error == nil {
                    //success bitches
                    let image = UIImage(data: data!)
                    cell.postImageView.image = image
                } else {
                    //nah fam
                    print("Error downloading the image: \(error?.localizedDescription)")
                }
            })
        }
        
        cell.usernameLabel.alpha = 0
        cell.contentTextView.alpha = 0
        cell.postImageView.alpha = 0
        cell.locationLabel.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            cell.usernameLabel.alpha = 1
            cell.contentTextView.alpha = 1
            cell.postImageView.alpha = 1
            cell.locationLabel.alpha = 1
        })
        
        return cell
    }
    
    @objc func refreshPage() {
        refresher.endRefreshing()
        self.postsTableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
