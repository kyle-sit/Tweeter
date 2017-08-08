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

    //static instance for use in all of app
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/")! as URL!, consumerKey: "GEutc46f8dzb0vGxwiU0HcGm6", consumerSecret: "Gjr89aNAx54DzJGkrJbvsoRN4ZhNpojwu6h1ruIFacQrfpNi8e")
    
    //login succes and failure variable closures which allow me to detect success or failure at top level
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    //function for logging in
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        //have to logout first to avoid bugs
        TwitterClient.sharedInstance?.deauthorize()
        
        //getting request token to send to url to allow authorization of this app
        //remember importance of setting callback URL in info->URL type->set identifier and scheme
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"tweeter://oauth") as URL!, scope: nil, success: { (requestToken:BDBOAuth1Credential?) in

            //login success sends us to url to accept authorization
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url as URL)
        
        }, failure: { (error: Error?) in
            
            //failure results in printing error and sending back
           // print("error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error! as NSError)
        })
    }
    
    
    //logout function
    func logout() {
        //clear current user and logout
        User.currentUser = nil
        deauthorize()
        
        //post notificaiton for app delegate to see
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    
    //function to retrieve current logged in account and gain access to its information
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            //store dictionary from api call into User class
            let userDictionary  = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            //return it to be used by caller
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    
    //function for obtaining access token for all api calls
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            
            //currentAccount call to set currentUser
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            //print("error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error! as NSError)
        })
    }
    
    
    //function to grab array of timeline tweets from api and store them in Model
    //passes in a closure so that we can hand back all tweets on success
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    
    //method to send tweet to api
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
