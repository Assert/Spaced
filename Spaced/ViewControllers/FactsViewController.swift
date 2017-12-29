//
//  TaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 22/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

class FactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    public var taskIdList: [String] = []
    public var taskNameList: [String] = []

    public var selectedCategoryId: String?
    public var selectedCategoryName: String?
    public var selectedTaskId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedCategoryName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let categoryId = selectedCategoryId else { return }
        loadTasks(categoryId: categoryId)
    }
    
    public func loadTasks(categoryId: String) {
        taskNameList = []
        Tasks.all(categoryId: categoryId, completion: { (tasks) in
            tasks?.forEach({ (task) in
                self.taskIdList.append(task.id)
                self.taskNameList.append(task.question)
            })
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTaskSegue" {
            if let vc = segue.destination as? NewFactViewController {
                vc.selectedCategoryId = selectedCategoryId
            }
        }
        
        if segue.identifier == "ViewTaskSegue" {
            if let vc = segue.destination as? FactViewController {
                vc.selectedCategoryId = selectedCategoryId
                vc.selectedTaskId = selectedTaskId
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNameList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskNameList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedTaskId = taskIdList[indexPath.row]
        return indexPath
    }
}
