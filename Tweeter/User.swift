//
//  User.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/23/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenName: NSString?
    var profileURL: NSURL?
    var backgroundURL: NSURL?
    var tagline: NSString?
    var followers: Int?
    var following: Int?
    var numTweets: Int?
    
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String as NSString?
        screenName = dictionary["screen_name"] as? String as NSString?
        tagline = dictionary["description"] as? String as NSString?
        followers = (dictionary["followers_count"] as! Int)
        following = (dictionary["friends_count"] as! Int)
        numTweets = (dictionary["statuses_count"] as! Int)
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            let normalSized = profileURLString.replacingOccurrences(of: "_normal.", with: ".", options: .literal, range: nil)
            profileURL = NSURL(string: normalSized)
        }
        
        let backgroundURLString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundURLString = backgroundURLString {
            let normalSized2 = backgroundURLString.replacingOccurrences(of: "_normal.", with: ".", options: .literal, range: nil)
            backgroundURL = NSURL(string: normalSized2)
        }
        
        
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
