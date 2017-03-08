//
//  DetailsViewController.swift
//  Tweeter
//
//  Created by Kyle Sit on 3/1/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tweeterImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numFavorites: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favorited: Bool = false
    var retweeted: Bool = false
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweeterImage.setImageWith(tweet?.person?.profileURL as! URL)
        tweeterImage.layer.cornerRadius = 4
        tweeterImage.clipsToBounds  = true
        
        username.text = tweet?.person?.name as String?
        handle.text = "@\((tweet?.person?.screenName as String?)!)"
        tweetText.text = tweet?.text as String?
        
        let index = tweet?.timestamp?.description.index((tweet?.timestamp?.description.startIndex)!, offsetBy: 10)
        timestamp.text = tweet?.timestamp?.description.substring(to: index!)
        
        numFavorites.text = "\(tweet!.favoritesCount)"
        numRetweets.text = "\(tweet!.retweetCount)"
        
        let button2 = UIBarButtonItem(title: "reply", style: .plain, target: self, action: #selector(tappedOn)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if(!retweeted) {
            let retweetImage = UIImage(named: "retweet-icon-green")
            retweetButton.setImage(retweetImage, for: UIControlState.normal)
            let increment = Int(numRetweets.text!)
            numRetweets.text = "\(increment! + 1)"
            retweeted = true
        }
        else {
            let retweetImage = UIImage(named: "retweet-icon")
            retweetButton.setImage(retweetImage, for: UIControlState.normal)
            let decrement = Int(numRetweets.text!)
            numRetweets.text = "\(decrement! - 1)"
            retweeted = false
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if(!favorited) {
            let favoriteImage = UIImage(named: "favor-icon-red")
            favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
            let increment = Int(numFavorites.text!)
            numFavorites.text = "\(increment! + 1)"
            favorited = true
        }
        else {
            let favoriteImage = UIImage(named: "favor-icon")
            favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
            let decrement = Int(numFavorites.text!)
            numFavorites.text = "\(decrement! - 1)"
            favorited = false
        }
    }
    
    func tappedOn() {
        performSegue(withIdentifier: "composeTweet1", sender: DetailsViewController.self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
