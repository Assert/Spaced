//
//  CategoriesViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    private var categoryList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    public func loadCategories() {
        Categories.all { (categories) in
            categories?.forEach({ (cat) in
                self.categoryList.append(cat.name)
            })
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row >= categoryList.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! CategoryInputTableViewCell
            cell.configure(text: "", placeholder: "Category name")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = categoryList[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    // Row selected
    public func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        print("Row \(didSelectRowAt.row) selected")
        performSegue(withIdentifier: "tasksSegue", sender: self)
    }
    
    @IBAction func setEditMode(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
        if(self.tableView.isEditing == true) {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
