//
//  HomeViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import UserNotifications
import Crashlytics

class HomeViewController: UIViewController {

    @IBOutlet var tipOfTheDay: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = self

        showTipOfTheDay()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 10, y: 115, width: 100, height: 30)
        button.setTitle("Test a crash :/", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    func showTipOfTheDay() {
//        let tip = "A tip of the day is a snippet of practical advice that may be offered on a daily basis to users and readers of a website, newspaper, magazine, software program or media broadcast."
        
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
        
//        let subtitle = response.notification.request.content.subtitle
        let userInfo = response.notification.request.content.userInfo as NSDictionary

        if let categoryId = userInfo["categoryId"] as? String, let factId = userInfo["factId"] as? String {
            // Deeplink to answer page
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Fact") as? FactViewController
            vc?.selectedCategoryId = categoryId
            vc?.selectedTaskId = factId
            self.navigationController?.pushViewController(vc!, animated: true)
        }

        completionHandler()
    }
}
