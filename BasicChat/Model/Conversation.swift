//
//  Conversation.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import Foundation


///Zeige alle Messages für den ConversationtsController
//struct Conversation {
//    let user: User
//    let message: Message
//}


import FirebaseFirestore
import FirebaseAuth

class Conversation: Codable {
        
    //MARK: - Properties
    
    ///The unique identifier for each conversation.
    let identifier: String
    
    ///The conversation participants.
    let users: [String]
    
    let lastModifiedDate: Date
    
    var lastMessage: Message {
        return Message(messageText: "", receiverID: "", senderID: "", sentDate: Date(), conversationID: "")
    }
    
    //MARK: - Helper
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: lastModifiedDate)
    }
    
    //MARK: - Initializer
    
    internal init(users: Set<String>) {
        self.identifier = UUID().uuidString
        self.users = Array(users)
        self.lastModifiedDate = Date()
    }
    
    internal init(dictionary: [String: Any]) {
        
        let data = dictionary
        
        if let identifier = data["identifier"] as? String {
            self.identifier = identifier
        } else {
            self.identifier = "Error @identifier"
        }
        
        if let users = data["users"] as? [String] {
            self.users = users
        } else {
            self.users = []
        }
        
        if let lastModifiedDate = data["lastModifiedDate"] as? Timestamp {
            let date = lastModifiedDate.dateValue()
            self.lastModifiedDate = date
        } else {
            self.lastModifiedDate = Date()
        }
    }
    
    //MARK: - Firebase Initializer
    
    ///Initializer for Firebase
    init?(document: QueryDocumentSnapshot) {
        
        let data = document.data()
        
        if let identifier = data["identifier"] as? String {
            self.identifier = identifier
        } else {
            self.identifier = "Error @identifier"
        }
        
        if let users = data["users"] as? [String] {
            self.users = users
        } else {
            self.users = []
        }
        
        if let lastModifiedDate = data["lastModifiedDate"] as? Timestamp {
            let date = lastModifiedDate.dateValue()
            self.lastModifiedDate = date
        } else {
            self.lastModifiedDate = Date()
        }
    }
}

//MARK: - DataRepresentation

extension Conversation: DataRepresentation {
    
    var representation: [String : Any] {
        let rep = ["identifier": identifier, "users": users, "lastModifiedDate": lastModifiedDate] as [String : Any]
        
        return rep
    }
}

//MARK: - Equatable

extension Conversation: Equatable {
    
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
