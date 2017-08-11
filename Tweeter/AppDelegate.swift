//
//  AppDelegate.swift
//  Tweeter
//
//  Created by Kyle Sit on 2/23/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //check if there is an existing user, if so we go directly to home timeline
        if User.currentUser != nil {
            print("There is a current user")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
            window?.rootViewController = vc
            
            //Home tab bar
            let homeNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
            homeNavController.tabBarItem.title = "Home"
            homeNavController.tabBarItem.image = UIImage(named: "home-icon")
            
            //Profile tab bar
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileViewController.user = User.currentUser
            profileViewController.tabBarItem.title = "User Profile"
            profileViewController.tabBarItem.image = UIImage(named: "profile-icon")
            
            //Tab bar controller allows you to move between both tabs
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [homeNavController, profileViewController]
            tabBarController.tabBar.barTintColor = UIColor(red: 0.251, green: 0.8588, blue: 0.9765, alpha: 1.0)
            
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        } 
    
        //looks for user logout notification and resets storyboard 
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLogout"), object: nil, queue: OperationQueue.main) { (Notification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //function gets called when app is opened from web
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //print(url.description)
        
        //call a method to retrieve access token for api
        TwitterClient.sharedInstance?.handleOpenUrl(url: url as NSURL)
        
        return true
    }
    
}

