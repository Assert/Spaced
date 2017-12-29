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
    
    private var categoryNameList: [String] = []
    private var categoryIdList: [String] = []
    public var selectedCategoryId: String?
    private var selectedCategoryName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    // Remove the keyboard when loading view (used on back)
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // Todo: remove keyboard when touch ouside keyboard
    
    public func loadCategories() {
        categoryNameList = []
        categoryIdList = []
        Categories.all { (categories) in
            categories?.forEach({ (cat) in
                self.categoryNameList.append(cat.name)
                self.categoryIdList.append(cat.id)
            })
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNameList.count + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row >= categoryNameList.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! CategoryInputTableViewCell
            cell.configure(text: "", placeholder: "New category...")
            cell.updateCallback = gotoTasks
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = categoryNameList[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func gotoTasks(categoryId: String, categoryName: String) {
        self.loadCategories()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TasksView") as? FactsViewController
        vc?.selectedCategoryId = categoryId
        vc?.selectedCategoryName = categoryName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategoryId = categoryIdList[indexPath.row]  // Kan få error her categoryIdList=1 (indexPath.row=1 som er create)
        // Tror det har noe med at keyboard ikke forsvinner når man går tilbake uten å lage fact
        // resignFirstResponder
        selectedCategoryName = categoryNameList[indexPath.row]
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FactsSegue" {
            if let vc = segue.destination as? FactsViewController {
                vc.selectedCategoryId = selectedCategoryId
                vc.selectedCategoryName = selectedCategoryName
            }
        }
    }
    
    @IBAction func setEditMode(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
        if(self.tableView.isEditing == true) {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedCategoryId = categoryIdList[indexPath.row]
            FirestoreHelper().deleteCategory(categoryId: selectedCategoryId)
            
            categoryIdList.remove(at: indexPath.row)
            categoryNameList.remove(at: indexPath.row)

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
