//
//  CategoryInputTableViewCell.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

public class CategoryInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var categoryName: UITextField!
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let category = textField.text else { return false }
        
        FirestoreHelper().writeCategory(name: category)
        
        textField.resignFirstResponder();
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
