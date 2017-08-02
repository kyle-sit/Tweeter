//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/26/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //tableview outlet
    @IBOutlet weak var tweetsTableView: UITableView!    
    
    //instance variable array for tweets
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting delegagtes and datasource
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        
        //autolayout dimensions
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 160
        
        //setting naviation bar color
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 0.251, green: 0.8588, blue: 0.9765, alpha: 1.0)
        }
        
        //initial population of tableview
        getTweets()
        
        //setting a tweet button in the top right bar button
        let button3 = UIBarButtonItem(image: UIImage(named: "edit-icon"), style: .plain, target: self, action: #selector(tappedOn)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button3
        
        self.tweetsTableView.reloadData()
    }

    
    //memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //onclick method for logout button
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    //method for tableview row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        else {
            return 0
        }
    }
    
    
    //function setting contents fo tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeuing individual tweet cell
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        //Prof Pic stuff including Segue
        cell.profPic.setImageWith(tweet.person?.profileURL as! URL)
        cell.profPic.isUserInteractionEnabled = true
        cell.profPic.tag = indexPath.row
        
        //setting tap gesture recognizer on prof pic
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
    
    
    //function to deselect cell color
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tweetsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //function encapsulating populating home timeline
    func getTweets() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
        
        self.tweetsTableView.reloadData()
    }
    
    
    //handling segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toProfileVC") {
            let image = sender as! UIImageView
            let index = (image.tag) as Int
            let tweet = tweets[index]
            let user = tweet.person
            
            let detailViewController = segue.destination as! ProfileViewController
            detailViewController.user = user
        }
        else if(segue.identifier == "toDetails"){
            let cell = sender as! TweetCell
            let indexPath = tweetsTableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as! DetailsViewController
            detailViewController.tweet = tweet
        }
        else {
            if segue.identifier == "composeTweets3" {
                let destination = segue.destination as! ComposeViewController
                destination.composeDelegate = self;
            }
        }
    }
 
    func tapOnProfPic(recognizer:UITapGestureRecognizer) {
        guard let imageView = recognizer.view as? UIImageView
            else{return}
        self.performSegue(withIdentifier: "toProfileVC", sender: imageView)
    }
    
    func tappedOn() {
        performSegue(withIdentifier: "composeTweet3", sender: TweetsViewController.self)
    }
    
    func getTweets() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
        
        self.tweetsTableView.reloadData()
        
    }

}

extension TweetsViewController: ComposeVCDelegate{
    func uploadTweet(tweet: Tweet) {
        getTweets()
        tweetsTableView.reloadData() //reload
    }
}
