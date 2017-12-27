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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    public func loadCategories() {
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
            cell.configure(text: "", placeholder: "Category name")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = categoryNameList[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    // Row selected
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategoryId = categoryIdList[indexPath.row]
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FactsSegue" {
            if let vc = segue.destination as? TaskViewController {
                vc.selectedCategoryId = selectedCategoryId
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
