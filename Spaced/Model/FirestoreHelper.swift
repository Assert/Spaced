//
//  FirestoreHelper.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import Foundation
import Firebase

struct Categories: Codable {
    let id: String
    let name: String
}


extension Categories {
    static func all(completion: @escaping ([Categories]?) -> ()) {
        let db = Firestore.firestore()
        db.collection("category").getDocuments { (snap, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                let artists: [Categories] = snap!.documents.flatMap({
                    var json = $0.data()
                    json["id"] = $0.documentID
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                        let decoder = JSONDecoder()
                        return try? decoder.decode(Categories.self, from: jsonData)
                    }
                    return nil
                })
                completion(artists)
            }
        }
    }
}

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
