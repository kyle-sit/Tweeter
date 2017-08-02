//
//  TweetCell.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/26/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    //outlets
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    //instance variables
    var favorited: Bool = false
    var retweeted: Bool = false
    
    //var tweet: Tweet?
    
    //awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // round out prof pic edges
        profPic.layer.cornerRadius = 4
        profPic.clipsToBounds  = true
        
        //autolayout
        username.preferredMaxLayoutWidth = username.frame.size.width
    }
    
    
    //layoutSubViews
    override func layoutSubviews() {
        super.layoutSubviews()
        //autolayout
        username.preferredMaxLayoutWidth = username.frame.size.width
    }

    
    //animates a cell when selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //onclick method for favorite button
    @IBAction func onFavorite(_ sender: Any) {
        //change image to favorited icon
        if(!favorited) {
            let favoriteImage = UIImage(named: "favor-icon-red")
            favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
            let increment = Int(favoriteCount.text!)
            favoriteCount.text = "\(increment! + 1)"
            favorited = true
        }
        //reset image to regular icon
        else {
            let favoriteImage = UIImage(named: "favor-icon")
            favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
            let decrement = Int(favoriteCount.text!)
            favoriteCount.text = "\(decrement! - 1)"
            favorited = false
        }
    }
    
    
    //onclick method for retweet button
    @IBAction func onRetweet(_ sender: Any) {
        //change image to retweeted icon
        if(!retweeted) {
            let retweetImage = UIImage(named: "retweet-icon-green")
            retweetButton.setImage(retweetImage, for: UIControlState.normal)
            let increment = Int(retweetCount.text!)
            retweetCount.text = "\(increment! + 1)"
            retweeted = true
        }
        //change image to regular icon
        else {
            let retweetImage = UIImage(named: "retweet-icon")
            retweetButton.setImage(retweetImage, for: UIControlState.normal)
            let decrement = Int(retweetCount.text!)
            retweetCount.text = "\(decrement! - 1)"
            retweeted = false
        }
    }
    
}
