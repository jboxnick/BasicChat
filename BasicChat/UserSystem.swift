//
//  UserSystem.swift
//  BasicChat
//
//  Created by Julian Boxnick on 25.09.22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class UserSystem {
    
    static let shared = UserSystem()
    
    //MARK: - Firebase Database References
    
    ///The root reference to the FirebaseDatabase
    let databaseReference = Database.database(url: "https://basicchat-89e2d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    //MARK: - Firebase Firestore References
    
    ///The root reference to the FirebaseFirestore
    let firestoreReference = Firestore.firestore()
    
    //MARK: - Listener Registrations
    
    ///The listener for all user documents stored inside FirebaseFirestore
    var allUsersListener: ListenerRegistration?
    
    ///The listener for  the current users document  stored inside FirebaseFirestore
    var currentUserListener: ListenerRegistration?
    
    //MARK: - Current User
    
    ///The current user
    var user: User? {
        didSet {
            if user != nil {
                guard let _ = user else { return }
            }
        }
    }
    
    ///The current users ID
    var currentUserID: String {
        guard let userID = Auth.auth().currentUser?.uid else { return "Error @userID" }
        return userID
    }
    
    //MARK: - User Session Listener
    
    ///Get the current users data from FirebaseFirestore
    func getCurrentUser(completion: @escaping (User) -> Void) {
        
        let userDocRef = Firestore.firestore().users.document(currentUserID)
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let user = User(dictionary: data)
                completion(user)
            } else {
                print("Document for current user does not exist")
            }
        }
    }
    
    func addUserSessionListener(_ update: @escaping (Bool) -> Void) {
        
        databaseReference.child("user_sessions").child(currentUserID).observe(.value) { (snapshot) in
            if let snapshotValue = snapshot.value {
                if snapshotValue as? Bool == true {
                    // The current session is valid.
                    update(true)
                } else {
                    // The current session is invalid.
                    
                    // Remove observer
                    self.removeUserSessionListener()
                    
                    // Logout current user
                    AuthenticationService.logoutUser()
                    update(false)
                }
            }
        }
    }
    
    func removeUserSessionListener() {
        
        databaseReference.child("user_sessions").child(self.currentUserID).removeAllObservers()
    }
    
    //MARK: - General User Query Functions
    
    ///Start listening for current user
    func addCurrentUserListener(_ update: @escaping () -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        currentUserListener = firestoreReference.users.document(userID).addSnapshotListener { snapshot, error in
            
            guard let document = snapshot else { return }
            guard let data = document.data() else { return }
            
            let onlineUser = User(dictionary: data)
            
            let userDefaults = UserDefaults.standard
            
            do {
                try userDefaults.setObject(onlineUser, forKey: userID)
                UserSystem.shared.user = onlineUser
                print("User was updated to UserDefaults.")
                update()
            } catch {
                print("Not able to update the user to UserDefaults.")
            }
        }
    }
    
    ///Stop listening for current user
    func removeCurrentUserListener() {
        
        currentUserListener?.remove()
        user = nil
    }
    
    //MARK: - Other Users
    
    public var users = [User]()
    
    ///Start listening for all app users
    func addUsersObserver(_ update: @escaping () -> Void) {
        
        allUsersListener = firestoreReference.users.addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else { return }
            
            snapshot.documentChanges.forEach { change in
                
                guard let user = User(document: change.document) else { return }
                
                switch change.type {
                    
                case .added:
                    self.addUserToTable(user)
                case .modified:
                    self.updateUserInTable(user)
                case .removed:
                    self.removeUserFromTable(user)
                }
                update()
            }
        }
    }
    
    ///Stop listening for all app users
    func removeUsersObserver() {
        
        allUsersListener?.remove()
        users.removeAll()
    }
    
    //MARK: - Helper Functions
    
    ///Remove all observers for FirebaseDatabase and FirebaseFirestore
    func removeAllObservers() {
        
        removeUserSessionListener()
        removeCurrentUserListener()
        removeUsersObserver()
    }
    
    //MARK: - User Table Functions
    
    private func addUserToTable(_ user: User) {
        
        let nc = NotificationCenter.default
        
        guard !users.contains(user) else { return }
        guard user.userID != self.currentUserID else { return }
        
        users.append(user)
        
        guard let index = users.firstIndex(of: user) else { return }
        
        nc.post(name: Notification.Name("insertRows"), object: nil, userInfo: ["identifier": "users", "index" : index, "section": 0])
    }
    
    private func updateUserInTable(_ user: User) {
        
        let nc = NotificationCenter.default
        
        guard let index = users.firstIndex(of: user) else { return }
        
        users[index] = user
        
        nc.post(name: Notification.Name("reloadRows"), object: nil, userInfo: ["identifier": "users", "index" : index, "section": 0])
    }
    
    private func removeUserFromTable(_ user: User) {
        
        let nc = NotificationCenter.default
        
        guard let index = users.firstIndex(of: user) else { return }
        
        users.remove(at: index)
        
        nc.post(name: Notification.Name("deleteRows"), object: nil, userInfo: ["identifier": "users", "index" : index, "section": 0])
    }
}
