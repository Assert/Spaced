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
    
    var updateCallback : (()-> Void)?
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let category = textField.text else { return false }
        
        FirestoreHelper().writeCategory(name: category)
        
        Analytics.logEvent("category_created", parameters: [
            "name": category as NSObject
            ])
        
        textField.resignFirstResponder()
        
        updateCallback?()

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
