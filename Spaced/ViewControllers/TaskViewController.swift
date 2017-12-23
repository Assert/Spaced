//
//  TaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

//class TaskViewController: NSObject {
class TaskViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        
        writeTask()
    }
    
    func writeTask() {
        let db = Firestore.firestore()
        
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("tasks").addDocument(data: [
            "title": "Napolion",
            "description": "When did Napolion.....?",
            "isPublic": false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

}
