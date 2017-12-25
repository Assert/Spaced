//
//  FirestoreHelper.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import Foundation
import Firebase

class FirestoreHelper {

    private let db = Firestore.firestore()
    
    func writeFact(question: String, answer: String) {
        db.collection("tasks").addDocument(data: [
            "question": question,
            "answer": answer,
            "isPublic": false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    func writeCategory(name: String) {
        db.collection("category").addDocument(data: [
            "name": name
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
}
