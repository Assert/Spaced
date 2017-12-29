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

typealias IntervalStep = Int

struct ScheduleNotification {
    
    private static func incBadgetCount(badge: NSNumber?) -> NSNumber {
        if let oldCount = badge as? Int {
            let newCount = NSNumber(value: oldCount + 1)
            return newCount
        } else {
            return 1
        }
    }

    static func decBadgetCount(badge: NSNumber?) -> NSNumber {
        guard let oldCount = badge as? Int else { return 0 }
        let newCount = oldCount - 1
        if (newCount > 0) {
            return NSNumber(value: newCount)
        } else {
            return 0
        }
    }

    // Create Notification trigger
    private static func set(notification: NotificationBody, completion: @escaping (Bool) -> ()) {
        
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
        notificationContent.badge = incBadgetCount(badge: notificationContent.badge)
        
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
    
    static func send(factId: String, categoryId: String, question: String, intervalStep: IntervalStep) {
        let notificationId = factId // Use the same
        
        let title = "Do you remember?"
        let body = "Lorem ipsum"
        let intervalInSeconds = getInterval(t: intervalStep)
        
        let notification = NotificationBody(id: notificationId, factId: factId, categoryId: categoryId, title: title, subtitle: question, body: body, inSeconds: intervalInSeconds, repeats: false)
        
        ScheduleNotification.set(notification: notification, completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
    }
    
    private static func nextInterval(t: IntervalStep) -> IntervalStep {
        let max = 7
        if (t < max) {
            return t+1
        } else {
            return max
        }
    }
    
    private static func preInterval(t: IntervalStep) -> IntervalStep {
        if (t > 0) {
            return t-1
        } else {
            return 0
        }
    }
    
    private static func getInterval(t: IntervalStep) -> TimeInterval {
        switch t {
        case 0:
            return TimeInterval(3600) // 1h
        case 1:
            return TimeInterval(18000) // 5h
        case 2:
            return TimeInterval(86400)  // 1day
        case 3:
            return TimeInterval(172800) // two days
        case 4:
            return TimeInterval(345600)   // four days
        case 5:
            return TimeInterval(518400)   // Six days
        case 6:
            return TimeInterval(1209600)  //12
        case 7:
            return TimeInterval(2592000)     // 30 days
        default:
            return TimeInterval(345600) // four days
        }
    }
    
    static func correctAnswer(t: IntervalStep) -> IntervalStep {
        return nextInterval(t: t)
    }
    
    static func wrongAnswer(t: IntervalStep) -> IntervalStep {
        return preInterval(t: t)
    }
    
    static func snooze(t: IntervalStep) -> IntervalStep {
        return t
    }
    

}

