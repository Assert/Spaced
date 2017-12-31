//
//  NewTaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 23/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

class NewFactViewController: UIViewController {

    @IBOutlet var question: UITextField!
    @IBOutlet var answer: UITextField!
    
    public var selectedCategoryId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        question.becomeFirstResponder()
        question.autocapitalizationType = UITextAutocapitalizationType.sentences
        question.spellCheckingType = UITextSpellCheckingType.yes
        answer.autocapitalizationType = UITextAutocapitalizationType.sentences
        answer.spellCheckingType = UITextSpellCheckingType.yes
    }
    
    @IBAction func saveNewTask(_ sender: UIButton) {
        guard let question = question.text, let answer = answer.text else { return }
        guard let categoryId = selectedCategoryId else { return }
        
        FirestoreHelper().writeFact(categoryId: categoryId, question: question, answer: answer) { docId in
            guard let factId = docId else { return }
            
            ScheduleNotification.send(factId: factId, categoryId: categoryId, question: question, intervalStep: 0)
            
            Analytics.logEvent("fact_created", parameters: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
    }

   
    
}
