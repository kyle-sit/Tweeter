//
//  TweetCell.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/26/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    //var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profPic.layer.cornerRadius = 4
        profPic.clipsToBounds  = true
        
        username.preferredMaxLayoutWidth = username.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        username.preferredMaxLayoutWidth = username.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavorite(_ sender: Any) {
        let favoriteImage = UIImage(named: "favor-icon-red")
        favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
        let increment = Int(favoriteCount.text!)
        favoriteCount.text = "\(increment! + 1)"
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        let retweetImage = UIImage(named: "retweet-icon-green")
        retweetButton.setImage(retweetImage, for: UIControlState.normal)
        let increment = Int(retweetCount.text!)
        retweetCount.text = "\(increment! + 1)"
    }
    
}