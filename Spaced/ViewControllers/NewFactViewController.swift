//
//  NewTaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 23/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class NewFactViewController: UIViewController {

    @IBOutlet var question: UITextField!
    @IBOutlet var answer: UITextField!
    
    public var selectedCategoryId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveNewTask(_ sender: UIButton) {
        guard let question = question.text, let answer = answer.text else { return }
        guard let categoryId = selectedCategoryId else { return }
        
        FirestoreHelper().writeFact(categoryId: categoryId, question: question, answer: answer) { docId in
            guard let notificationId = docId else { return }
            
            let title = "Do you remember?"
            let body = "Lorem ipsum"
            let intervalInSeconds = TimeInterval(120)
            
            let notification = NotificationBody(id: notificationId, title: title, subtitle: question, body: body, inSeconds: intervalInSeconds, repeats: true)
            ScheduleNotification.set(notification: notification, completion: { success in
                if success {
                    print("Successfully scheduled notification")
                } else {
                    print("Error scheduling notification")
                }
            })
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
