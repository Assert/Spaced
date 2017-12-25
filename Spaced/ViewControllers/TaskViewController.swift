//
//  TaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

class TaskViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
    }
        
    @IBAction func gotoNewFact(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newTaskSegue", sender: self)
    }
}
