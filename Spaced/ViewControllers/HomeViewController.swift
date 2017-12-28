//
//  HomeViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {

    @IBOutlet var tipOfTheDay: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = self

        showTipOfTheDay()
    }

    func showTipOfTheDay() {
        let tip = "A tip of the day is a snippet of practical advice that may be offered on a daily basis to users and readers of a website, newspaper, magazine, software program or media broadcast."
        
      //  tipOfTheDay.text = tip
    }
    
    @IBAction func gotoTasks(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
}

extension HomeViewController: UNUserNotificationCenterDelegate {
    
    // Called when a notification is delivered to a foreground app
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("📲 Foreground notification")
        
        let subtitle = notification.request.content.subtitle
        
        let userInfo = notification.request.content.userInfo as NSDictionary
        if let categoryId = userInfo["categoryId"], let factId = userInfo["factId"] {
            print("\(subtitle) - \(categoryId) - \(factId) ")
            // Re-schedule or show?
        }
    }
    
    // Called when a notification is delivered to a background app and user opens it
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("📲 Background notification tapped")
        
        let subtitle = response.notification.request.content.subtitle
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary

        if let categoryId = userInfo["categoryId"], let factId = userInfo["factId"] {
            print("\(subtitle) - \(categoryId) - \(factId) ")
            // Go to deeplink
        }

        completionHandler()
    }
}
