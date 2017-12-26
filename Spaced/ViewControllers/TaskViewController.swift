//
//  TaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var categoryList: [String] = ["nnjj","jkk","ggggg"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoNewFact(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newTaskSegue", sender: self)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
