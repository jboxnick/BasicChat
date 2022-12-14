//
//  User.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import Foundation
import FirebaseFirestore

protocol DataRepresentation {
    
    var representation: [String: Any] { get }
}

class User: Codable {
    
    //MARK: - Properties
    
    ///The unique identifier for each user account.
    let userID: String
    
    ///The users username
    let username: String
    
    ///The users email adress.
    let emailAdress: String
    
    ///The reference to the users profile picture.
    let profilePictureURL: String?
    
    //MARK: - Initializer
    
    //Full user
    internal init(userID: String, username: String, emailAdress: String, profilePictureURL: String?) {
        self.userID = userID
        self.username = username
        self.emailAdress = emailAdress
        self.profilePictureURL = profilePictureURL
    }
    
    internal init(dictionary: [String: Any]) {
        
        let data = dictionary
        
        if let userID = data["userID"] as? String {
            self.userID = userID
        } else {
            self.userID = "Error @userID"
        }
        
        if let username = data["username"] as? String {
            self.username = username
        } else {
            self.username = "Error @username"
        }
        
        if let emailAdress = data["emailAdress"] as? String {
            self.emailAdress = emailAdress
        } else {
            self.emailAdress = "Error @emailAdress"
        }
        
        if let profilePictureURL = data["profilePictureURL"] as? String {
            self.profilePictureURL = profilePictureURL
        } else {
            self.profilePictureURL = Constants.Others.defaultProfilePictureURL
        }
    }
    
    //MARK: - Firebase Initializer
    
    ///Initializer for Firebase
    init?(document: QueryDocumentSnapshot) {
        
        let data = document.data()
        
        if let userID = data["userID"] as? String {
            self.userID = userID
        } else {
            self.userID = "Error @userID"
        }
        
        if let username = data["username"] as? String {
            self.username = username
        } else {
            self.username = "Error @username"
        }
        
        if let emailAdress = data["emailAdress"] as? String {
            self.emailAdress = emailAdress
        } else {
            self.emailAdress = "Error @emailAdress"
        }
        
        if let profilePictureURL = data["profilePictureURL"] as? String {
            self.profilePictureURL = profilePictureURL
        } else {
            self.profilePictureURL = Constants.Others.defaultProfilePictureURL
        }
    }
}

//MARK: - DataRepresentation

extension User: DataRepresentation {
    
    var representation: [String : Any] {
        let rep = ["userID": userID, "username": username, "emailAdress": emailAdress, "profilePictureURL": profilePictureURL ?? Constants.Others.defaultProfilePictureURL] as [String : Any]
        
        return rep
    }
}

//MARK: - Equatable

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
}
