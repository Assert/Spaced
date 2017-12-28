//
//  FactViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 27/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

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
        print(answerQuestion())
        textField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        print(answerQuestion())
        self.navigationController?.popViewController(animated: true)

        return true
    }
    
    private func answerQuestion() -> Bool {
        guard let answer = self.textField.text else { return false }
        guard let correctAnswer = self.correctAnswer else { return false }
        return (answer == correctAnswer)
    }
    
    private func loadFact() {
        guard let categoryId = selectedCategoryId else { return }
        guard let taskId = selectedTaskId else { return }
        
        Tasks.one(categoryId: categoryId, taskId: taskId).then { (task) in
            self.correctAnswer = task.answer
            self.question.text = "What is \(task.question)?"
        }.catch({ (error) in
            print(error)
        })
    }
}
