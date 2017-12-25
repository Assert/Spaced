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
        
     //   let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("showEditing:")))
     //   self.navigationItem.rightBarButtonItem = rightButton
    }

    public func loadCategories() {
        Categories.all { (categories) in
            categories?.forEach({ (cat) in
                self.categoryList.append(cat.name)
            })
            self.tableView.reloadData()
        }
    }

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = categoryList[indexPath.row]
        return cell
    }

    
    
    @IBAction func gotoNewCategory(_ sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "newCategorySegue", sender: self)
        showEditing(sender: sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func showEditing(sender: UIBarButtonItem)
    {
        tableView.isEditing = !tableView.isEditing
        
        if(self.tableView.isEditing == true)
        {
            sender.title = "Done"
            
            //self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else
        {
            sender.title = "Edit"
            //self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
}
