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
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 160
        
        self.navigationController?.navigationBar.barTintColor = UIColor.cyan
        
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
        
        //Prof Pic stuff including Segue
        cell.profPic.setImageWith(tweet.person?.profileURL as! URL)
        cell.profPic.isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action: #selector(self.tapOnProfPic(recognizer:)))
        tapped.numberOfTapsRequired = 1
        tapped.numberOfTouchesRequired = 1
        cell.profPic.addGestureRecognizer(tapped)
        
        //Cell info
        cell.username.text = tweet.person?.name as String?
        cell.tweetText.text = tweet.text as String?
        
        //Editing timestamp
        let index = tweet.timestamp?.description.index((tweet.timestamp?.description.startIndex)!, offsetBy: 10)
        cell.timeStamp.text = tweet.timestamp?.description.substring(to: index!)
        
        //button numbers
        cell.favoriteCount.text = "\(tweet.favoritesCount)"
        cell.retweetCount.text = "\(tweet.retweetCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tweetsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toProfileVC") {
            
        }
        else {
            let cell = sender as! TweetCell
            let indexPath = tweetsTableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as! DetailsViewController
            detailViewController.tweet = tweet
        }
    }
 
    func tapOnProfPic(recognizer:UITapGestureRecognizer) {
        /*guard let imageView = recognizer.view as? UIImageView
            else{return}*/
        self.performSegue(withIdentifier: "toProfileVC", sender: recognizer)
    }

}
