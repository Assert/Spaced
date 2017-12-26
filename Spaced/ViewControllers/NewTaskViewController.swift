//
//  NewTaskViewController.swift
//  Spaced
//
//  Created by Eystein Bye on 23/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet var question: UITextField!
    @IBOutlet var answer: UITextField!
    
    public var selectedCategoryId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveNewTask(_ sender: UIButton) {
        guard let question = question.text, let answer = answer.text else { return }
        guard let categoryId = selectedCategoryId else { return }
        FirestoreHelper().writeFact(categoryId: categoryId, question: question, answer: answer)

        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
