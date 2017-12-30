//
//  HomeViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import UserNotifications
import Crashlytics

class HomeViewController: UIViewController {

    @IBOutlet var tipOfTheDay: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showTipOfTheDay()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 10, y: 115, width: 100, height: 30)
        button.setTitle("Test a crash :/", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    func showTipOfTheDay() {
//        let tip = "A tip of the day is a snippet of practical advice that may be offered on a daily basis to users and readers of a website, newspaper, magazine, software program or media broadcast."
        
      //  tipOfTheDay.text = tip
    }
    
    @IBAction func gotoTasks(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
}

