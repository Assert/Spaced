//
//  AppDelegate.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Setup Firebase
        FirebaseApp.configure()

        // Firebase login
        Auth.auth().signInAnonymously { (user, error) in
            if let user = user {
                print("🕵🏻 Firebase anonymouse login as user \(user.uid)")
            } else {
                print(error?.localizedDescription ?? "Error signing in to Firebase")
                //Hide tabs?
            }
        }
        
        // Request notification authorization
        ScheduleNotification.requestAuthorization()

        // Initialize the Google Mobile Ads SDK with AdMob app ID
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5259470458329777~9161080511")
        
        // Handle notification responses in AppDelegate
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // Getting the device push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Not available in simulator \(error)")
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

    // Called when a notification is delivered to a foreground app
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("📲 Foreground notification")
        
        let subtitle = notification.request.content.subtitle
        let userInfo = notification.request.content.userInfo as NSDictionary
        if let categoryId = userInfo["categoryId"] as? String, let factId = userInfo["factId"] as? String {
            print("\(subtitle) - \(categoryId) - \(factId) ")
            // Re-schedule since app is open
            let shortInterval = 0
            ScheduleNotification.send(factId: factId, categoryId: categoryId, question: subtitle, intervalStep: shortInterval)
        }
        completionHandler([.badge, .alert, .sound]) // Remove this line?
    }
    
    // Called when a notification is delivered to a background app and user opens it
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("📲 Background notification tapped")
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        if let categoryId = userInfo["categoryId"] as? String, let factId = userInfo["factId"] as? String {
            // Deeplink to answer page
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "AnswerFact") as? FactViewController
            vc?.selectedCategoryId = categoryId
            vc?.selectedTaskId = factId
            
            let tabCtrl = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
            if let answerVc = vc  {
                tabCtrl?.present(answerVc, animated: true, completion: nil)
            }
            completionHandler()
        }
    }
}

