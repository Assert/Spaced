//
//  CategoryInputTableViewCell.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

public class CategoryInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var categoryName: UITextField!
    
    var updateCallback : ((_ categoryId: String, _ categoryName: String)-> Void)?
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let category = textField.text else { return false }
        
        FirestoreHelper().writeCategory(name: category) { (categoryId) in
            guard let categoryId = categoryId else { return }
            guard let categoryName = self.categoryName.text else { return }
            
            self.updateCallback?(categoryId, categoryName)
        }
        
        Analytics.logEvent("category_created", parameters: [
            "name": category as NSObject
            ])
        
        textField.resignFirstResponder()
        

        return true;
    }

    public func configure(text: String?, placeholder: String) {
        categoryName.delegate = self
        categoryName.text = text
        categoryName.placeholder = placeholder
        
        categoryName.accessibilityValue = text
        categoryName.accessibilityLabel = placeholder
    }
}
