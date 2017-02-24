//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/24/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/")! as URL!, consumerKey: "GEutc46f8dzb0vGxwiU0HcGm6", consumerSecret: "Gjr89aNAx54DzJGkrJbvsoRN4ZhNpojwu6h1ruIFacQrfpNi8e")
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func currentAccount() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            let userDictionary  = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenName)")
            print("profile url: \(user.profileURL)")
            print("description: \(user.tagline)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
}
