//
//  NewCategoryViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 01/01/2018.
//  Copyright © 2018 Assert. All rights reserved.
//

import UIKit
import Firebase

class NewCategoryViewController: UIViewController {

    var updateCallback : ((_ categoryId: String, _ categoryName: String)-> Void)?

    @IBOutlet var categoryName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName.autocapitalizationType = UITextAutocapitalizationType.sentences
        categoryName.spellCheckingType = UITextSpellCheckingType.yes
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        guard let categoryName = categoryName.text else { return }
        
        FirestoreHelper().writeCategory(name: categoryName) { (categoryId) in
            guard let categoryId = categoryId else { return }
            guard let categoryName = self.categoryName.text else { return }
            
            self.updateCallback?(categoryId, categoryName)
        }
        
        Analytics.logEvent("category_created", parameters: [
            "name": categoryName as NSObject
            ])
                
        self.navigationController?.popViewController(animated: true)
    }
    

}
