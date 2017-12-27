//
//  FirestoreHelper.swift
//  Spaced
//
//  Created by Eystein Bye on 25/12/2017.
//  Copyright © 2017 Assert. All rights reserved.
//

import Foundation
import Firebase

struct Tasks: Codable {
    let id: String
    let question: String
    let answer: String
}

extension Tasks {
    static func all(categoryId: String, completion: @escaping ([Tasks]?) -> ()) {
        let db = Firestore.firestore()
        db.collection("category").document(categoryId).collection("tasks").getDocuments { (snap, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                let tasks: [Tasks] = snap!.documents.flatMap({
                    var json = $0.data()
                    json["id"] = $0.documentID
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                        let decoder = JSONDecoder()
                        return try? decoder.decode(Tasks.self, from: jsonData)
                    }
                    return nil
                })
                completion(tasks)
            }
        }
    }
    
    enum FirebaseError: Error {
        case documentNotFound
        case inactive
    }
    
    static func one(categoryId: String, taskId: String) -> AsyncOperation<Tasks> {
        let db = Firestore.firestore()
        
        return AsyncOperation { success, failure in
            db.collection("category").document(categoryId).collection("tasks").document(taskId)
                .getDocument(completion: { (snap, error) in
                    if let error = error {
                        print("Error getting document: \(error)")
                        failure(error)
                    } else {
                        guard snap!.exists else {
                            failure(FirebaseError.documentNotFound)
                            return
                        }
                        if var json = snap?.data() {
                            json["id"] = snap!.documentID
                            
//                            guard let active = json["active"] as? Bool, active == true else {
//                                failure(FirebaseError.inactive)
//                                return
//                            }
//
                            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                                let decoder = JSONDecoder()
                                if let artist = try? decoder.decode(Tasks.self, from: jsonData) {
                                    success(artist)
                                }
                            }
                        }
                    }
                })
        }
    }
    
}

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
    
    func writeFact(categoryId: String, question: String, answer: String) {
        db.collection("category").document(categoryId).collection("tasks").addDocument(data: [
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

    func deleteCategory(categoryId: String) {
        db.collection("category").document(categoryId).delete { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                print("Document deleted")
            }
        }
    }
/*
    func getTask(categoryId: String, taskId: String) {
        db.collection("category").document(categoryId).collection("tasks").document(taskId).getDocument { (snap
            , err) in
            
            snap?.data()
            
            
        }

        }
    }
*/
    
}
