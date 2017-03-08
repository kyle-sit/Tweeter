//
//  ComposeViewController.swift
//  Tweeter
//
//  Created by Kyle Sit on 3/7/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

protocol ComposeVCDelegate: class {
    func uploadTweet(tweet: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Handle: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    
    var reply: Tweet?
    var composeDelegate: ComposeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.delegate = self;
        tweetText.layer.cornerRadius = 6;
        tweetText.clipsToBounds = true;
        
        if(reply != nil) {
            tweetText.text = "@" + "\(reply?.person?.screenName as! String) ";
            tweetText.textColor = UIColor.black
        }
        else{
            tweetText.text = "What's up fam?"
            tweetText.textColor = UIColor.lightGray
        }
        
        self.Handle.text = User.currentUser?.screenName as String?
        self.Name.text = User.currentUser?.name as String?
        self.UserImage.setImageWith(User.currentUser?.profileURL as! URL)
        self.UserImage.layer.cornerRadius = 6;
        self.UserImage.clipsToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        //self.settingsDelegate?.didCancelSettings()
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func onTweet(_ sender: Any) {
        TwitterClient.sharedInstance?.tweetWithText(self.tweetText.text, inReplyToTweet: self.reply, success: { (tweet: Tweet) in
            
            print("WOAHHH")
            self.tweetText.resignFirstResponder()
            self.composeDelegate?.uploadTweet(tweet: tweet)
            self.dismiss(animated: true, completion: nil)
            
        }) { (error: Error?) in
            print(error?.localizedDescription as Any)
        }
        tweetText.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's up fam?"
            textView.textColor = UIColor.lightGray
        }
        else{
            textView.resignFirstResponder()
        }
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
