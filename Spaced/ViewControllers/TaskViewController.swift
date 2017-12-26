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

    @IBOutlet var tableView: UITableView!
    
    private var taskList: [String] = []
    
    public var selectedCategoryId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let categoryId = selectedCategoryId else { return }
        loadTasks(categoryId: categoryId)
    }
    
    public func loadTasks(categoryId: String) {
        Tasks.all(categoryId: categoryId, completion: { (tasks) in
            tasks?.forEach({ (task) in
                self.taskList.append(task.question)
            })
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
        })
    }

    @IBAction func gotoNewFact(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newTaskSegue", sender: self)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
