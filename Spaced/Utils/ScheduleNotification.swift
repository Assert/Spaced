//
//  ScheduleNotification.swift
//  Spaced
//
//  Created by Eystein Bye on 27/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationBody {
    let id: String
    let title: String
    let subtitle: String
    let body: String
    let inSeconds: TimeInterval
    let repeats: Bool
}

struct ScheduleNotification {
    
    // Create Notification trigger
    static func set(notification: NotificationBody, completion: @escaping (Bool) -> ()) {
        
        // Create Notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = notification.title
        notificationContent.subtitle = notification.subtitle
        notificationContent.body = notification.body
        
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
    
}
