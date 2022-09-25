//
//  FirestoreService.swift
//  BasicChat
//
//  Created by Julian Boxnick on 24.09.22.
//

import Foundation
import FirebaseFirestore

//MARK: - Firestore References

extension Firestore {
    
    /// Returns a reference to the conversations collection.
    var conversations: CollectionReference {
        return self.collection(Constants.Firebase.conversationsCollection)
    }
    
    /// Returns a reference to the users collection.
        var users: CollectionReference {
            return self.collection(Constants.Firebase.usersCollection)
        }
}

//MARK: - Write operations

extension Firestore {

    func add(user: User, onSuccess: @escaping () -> Void) {

        self.users.document(user.userID).setData(user.representation) { (error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
//    func add(category: ArticleCategory, onSuccess: @escaping () -> Void) {
//        
//        self.categories.document(category.identifier).setData(category.representation) { (error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            }
//            onSuccess()
//        }
//    }
}

//MARK: - Write Batch

extension WriteBatch {
    
    func add(user: User) {
        
        let document = Firestore.firestore().users.document(user.userID)
        self.setData(user.representation, forDocument: document)
    }
}
