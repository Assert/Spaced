//
//  HomeViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet var tipOfTheDay: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        
        showTipOfTheDay()
    }

    func showTipOfTheDay() {
        let tip = "A tip of the day is a snippet of practical advice that may be offered on a daily basis to users and readers of a website, newspaper, magazine, software program or media broadcast."
        
      //  tipOfTheDay.text = tip
    }
    
    
    @IBAction func gotoTasks(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
}

