//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/26/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        //tweetsTableView.rowHeight = UITableViewAutomaticDimension
        //tweetsTableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tweetsTableView.reloadData()
            /*for tweet in tweets {
                print(tweet.text!)
            }*/
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        
        self.tweetsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.profPic.setImageWith(tweet.person?.profileURL as! URL)
        cell.username.text = tweet.person?.screenName as String?
        cell.tweetText.text = tweet.text as String?
        cell.timeStamp.text = tweet.timestamp?.description
        
        return cell
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
