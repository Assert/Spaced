//
//  CategoryInputTableViewCell.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

public class CategoryInputTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryName: UITextField!
    
    public func configure(text: String?, placeholder: String) {
        categoryName.text = text
        categoryName.placeholder = placeholder
        
        categoryName.accessibilityValue = text
        categoryName.accessibilityLabel = placeholder
    }
}
