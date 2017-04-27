//
//  AppDelegate.swift
//  Swift Post Prototype
//
//  Created by something on 4/25/17.
//  Copyright © 2017 Pittsburgh TechHire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        postData()
        
        return true
    }

    func postData() {
        // var request = URLRequest(url: URL(string: "http://localhost:4567/post_id")!)  // test to same computer
        // var request = URLRequest(url: URL(string: "http://192.168.77.77:4567/post_id")!)  // test to different computer on local network
        var request = URLRequest(url: URL(string: "https://ios-post-proto-jv.herokuapp.com/post_id")!)  // test to Heroku-hosted app
        // let email = "mentor@ios_app.com"
        let email = "mig@ghi.com"  // test update email with no Firebase token
        
        // test for db record insert (no matching email)
        let fcm_id = "b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"
        
        // test for db record update (match on email)
        // let fcm_id = "k7_J3mLuQaC:SYH72aIMsA9blZX7hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"
        
        let postString = "email=\(email)&fcm_id=\(fcm_id)"
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
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


}

