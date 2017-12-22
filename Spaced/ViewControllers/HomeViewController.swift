//
//  HomeViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
    }

    @IBAction func gotoTasks(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
}

