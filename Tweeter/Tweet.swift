//
//  Tweet.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/23/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileURL: NSURL?
    
    var person: User?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String as NSString?
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        person = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
           let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}