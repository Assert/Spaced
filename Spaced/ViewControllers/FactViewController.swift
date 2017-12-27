//
//  FactViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 27/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class FactViewController: UIViewController {

    @IBOutlet var answer: UILabel!
    @IBOutlet var question: UILabel!
    
    public var selectedCategoryId: String?
    public var selectedTaskId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFact()
    }
    
    private func loadFact() {
        guard let categoryId = selectedCategoryId else { return }
        guard let taskId = selectedTaskId else { return }
        
        Tasks.one(categoryId: categoryId, taskId: taskId).then { (task) in
            self.answer.text = task.answer
            self.question.text = task.question
        }.catch({ (error) in
            print(error)
        })
    }
}
