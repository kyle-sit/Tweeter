//
//  Tweet.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/23/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    //instance variables
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var id: String?
    
    var person: User?
    
    //constructor
    init(dictionary: NSDictionary) {
        
        //set member variables
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        id = dictionary["id_str"] as? String
        person = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        //setting parameters for a time stamp on the tweet
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
           let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
    }
    
    
    //We receive tweets in an array so helper instance function to parse
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        //iterate through dict and create array of tweets
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
