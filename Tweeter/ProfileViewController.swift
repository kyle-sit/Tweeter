//
//  ProfileViewController.swift
//  Tweeter
//
//  Created by Kyle Sit on 3/6/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var userTweetsTableView: UITableView!
    
    var user: User?
    var composeDelegate: ComposeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //profPic
        userImage.setImageWith(user?.profileURL as! URL)
        userImage.layer.cornerRadius = 4
        userImage.clipsToBounds  = true
        //background Pic
        backgroundImage.setImageWith(user?.backgroundURL as! URL)
        
        //username and handle
        username.text = user?.name as String?
        handle.text = "@\((user?.screenName as String?)!)"
        
        //Statistics
        numFollowing.text = "\((user?.following)!)"
        numFollowers.text = "\((user?.followers)!)"
        numTweets.text = "\((user?.numTweets)!)"
        
        let button1 = UIBarButtonItem(image: UIImage(named: "edit-icon"), style: .plain, target: self, action: #selector(tappedOn)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedOn() {
        performSegue(withIdentifier: "composeTweet2", sender: ComposeViewController.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //setting compose delegate
        if(segue.identifier == "toComposeTweet2"){
            let navController = segue.destination as! UINavigationController
            let vc = navController.topViewController as! ComposeViewController
            vc.composeDelegate = self.composeDelegate
        }
    }

}
