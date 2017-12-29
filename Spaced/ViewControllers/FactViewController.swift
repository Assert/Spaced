//
//  FactViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 27/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit
import Firebase

class FactViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var question: UILabel!
    @IBOutlet var textField: UITextField!
    
    public var selectedCategoryId: String?
    public var selectedTaskId: String?
    
    private var correctAnswer: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self;
        self.textField.becomeFirstResponder()
        loadFact()
    }

    @IBAction func btnAnswer(_ sender: UIButton) {
        answerQuestion()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerQuestion()
        return true
    }
    
    private func answerQuestion() {
        textField.resignFirstResponder()
        guard let correctAnswer = self.correctAnswer else { return }

        if (checkQuestion()) {
            // update FB with correct answer

            let alert = UIAlertController(title: "Awsome", message: "Perfect!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Update FB with wrong answer

            let alert = UIAlertController(title: "Ops", message: "The correct answer is: \(String(describing: correctAnswer))", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func checkQuestion()  -> Bool {
        guard let answer = self.textField.text else { return false }
        guard let correctAnswer = self.correctAnswer else { return false }
        
        let wasCorrect = (answer == correctAnswer)
        
        Analytics.logEvent("answer_question", parameters: [
            "wasCorrect": wasCorrect as NSObject
        ])
        
        return wasCorrect
    }
    
    private func loadFact() {
        guard let categoryId = selectedCategoryId else { return }
        guard let taskId = selectedTaskId else { return }
        
        Tasks.one(categoryId: categoryId, factId: taskId).then { (task) in
            self.correctAnswer = task.answer
            self.question.text = "What is \(task.question)?"
        }.catch({ (error) in
            print(error)
        })
    }
}
