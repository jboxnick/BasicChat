//
//  AuthenticationService.swift
//  BasicChat
//
//  Created by Julian Boxnick on 25.09.22.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class AuthenticationService {
    
    //MARK: - Login User Function
    
    static func loginUser(_email: String, _password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {

        Auth.auth().signIn(withEmail: _email, password: _password) { (result, error) in

            if let err = error {
                UserDefaults.standard.set(false, forKey: "loginState")
                print(err.localizedDescription)
                onError(err.localizedDescription)
                return
            }

            UserDefaults.standard.set(true, forKey: "loginState")
            let userID = result!.user.uid
            print("Der User mit der UID: \(result!.user.uid) ist erfolgreich eingeloggt")

            let currentDate = Date()
//            UserDefaults.standard.set(currentDate, forKey: UserDefaults.Keys.Others.Auth.lastActiveDate.rawValue)
//            print("Saved \(currentDate) for key: \(UserDefaults.Keys.Others.Auth.lastActiveDate.rawValue)")
//            Firestore.firestore().users.document(result!.user.uid).updateData(["lastActiveDate" : currentDate])
            AppController.shared.updateRootVC()
            onSuccess()
        }
    }
    
    //MARK: - Logout User Function
    
    static func logoutUser() {
        
        UserDefaults.standard.set(false, forKey: "loginState")
        
        do {
            try Auth.auth().signOut()
            AppController.shared.updateRootVC()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - Create User Function
    
    static func createUser(_email: String, _password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: _email, password: _password) { (result, error) in
            
            if let err = error {
                print(err.localizedDescription)
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    //MARK: - Delete User Function
    
    static func deleteUser(onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { (error) in
            if let err = error {
                print(err.localizedDescription)
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    //MARK: - Delete User by ID Function
    
//    static func deleteUser(withUserID userID: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
//
//        guard UserSystem.shared.isAdminAccount else { return }
//
//        Firestore.firestore().users.document(userID).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//                print(err.localizedDescription)
//                onError(err.localizedDescription)
//            } else {
//                print("Account erfolgreich gelöscht!")
//                onSuccess()
//            }
//        }
//    }
    
    //MARK: - Update User Password Function
    
    static func updateUserPassword(_newPassword: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        user.updatePassword(to: _newPassword) { (error) in
            if let err = error {
                print(err.localizedDescription)
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    //MARK: - Reset Password User Function
    
    static func resetUserPassword(_email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: _email) { (error) in
            
            if let err = error {
                print(err.localizedDescription)
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    //MARK: - Update User eMail Function
    
    static func updateUserEmail(_newMailAdress: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        user.updateEmail(to: _newMailAdress) { (error) in
            
            if let err = error {
                print(err.localizedDescription)
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
}
