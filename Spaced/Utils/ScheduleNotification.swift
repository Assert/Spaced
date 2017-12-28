//
//  ScheduleNotification.swift
//  Spaced
//
//  Created by Eystein Bye on 27/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

// Call it: NotificationManager ?

import Foundation
import UserNotifications

struct NotificationBody {
    let id: String
    let factId: String
    let categoryId: String
    let title: String
    let subtitle: String
    let body: String
    let inSeconds: TimeInterval
    let repeats: Bool
}

struct ScheduleNotification {
    
    // Create Notification trigger
    static func set(notification: NotificationBody, completion: @escaping (Bool) -> ()) {
        
        let userInfo: [AnyHashable: Any] = [
            AnyHashable("factId"): notification.factId,
            AnyHashable("categoryId"): notification.categoryId
        ]
        
        // Create Notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = notification.title
        notificationContent.subtitle = notification.subtitle
        notificationContent.body = notification.body
        notificationContent.userInfo = userInfo
        
        // Note that 60 seconds is the smallest repeating interval.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.inSeconds, repeats: notification.repeats)
        
        // Create a notification request with the above components
        let request = UNNotificationRequest(identifier: notification.id, content: notificationContent, trigger: trigger)
        
        // Add this notification to the UserNotificationCenter
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("\(String(describing: error))")
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    

    static func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                print("Requesting Authorization")
                
                // Ask approval for push notifications
                center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    if granted {
                        print("Approval granted to send notifications")
                    }
                    if let error = error {
                        print("Request Authorization Failed (\(error), \(error.localizedDescription))")
                    }
                }
                //  Not needed?
                //        application.registerForRemoteNotifications()
                
            case .authorized:
                print("Notification approval already granted")
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    
}

