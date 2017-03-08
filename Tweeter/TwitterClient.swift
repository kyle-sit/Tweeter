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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"tweeter://oauth") as URL!, scope: nil, success: { (requestToken:BDBOAuth1Credential?) in
        print("Received Token")
        
        let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
        UIApplication.shared.open(url as URL)
        
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            let userDictionary  = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func tweetWithText(_ text: String, inReplyToTweet: Tweet?, success: @escaping (Tweet)->(), failure: @escaping (Error?)->()) {
        
        var params: [String: String] = [String: String]()
        params.updateValue(text, forKey: "status")
        
        if let tweet = inReplyToTweet {
            let replyTweetID = tweet.id! as String
            params.updateValue(replyTweetID, forKey: "in_reply_to_status_id")
        }
        
        self.post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetResponse = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetResponse)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }

    
    /*func retweet(success: (Tweet) -> (), failure: (NSError) -> ()) {

    }
    
    func favorite(success: (Tweet) -> (), failure: (NSError) -> ()) {

    }*/
    
}
