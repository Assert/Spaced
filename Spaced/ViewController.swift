//
//  ViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
/*
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("™")
        performSegue(withIdentifier: "categorySegue", sender: self)
    }
  */
    @IBAction func gotoTasks(_ sender: UIButton) {
        //performSegue(withIdentifier: "taskSegue", sender: self)
        //print("😎")
        self.tabBarController?.selectedIndex = 2
    }
    
}

