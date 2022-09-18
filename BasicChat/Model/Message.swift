//
//  Message.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Message {
    
    //MARK: - Properties
    
    ///The message content as text
    let messageText: String
    
    ///The receiverID
    let receiverID: String
    
    ///The senderID
    let senderID: String
    
    ///Date for message
    let sentDate: Date
    
    ///Bool whether message is from current user or not
    var isFromCurrentUser: Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return false }
        return senderID == currentUserID
    }
    
    var chatPartnerID: String {
        return isFromCurrentUser ? receiverID : senderID
    }
    
    var user: User?
    
    ///Unique identifier for each message
    let messageID: String
    
    //MARK: - Helper
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: sentDate)
    }
    
    //MARK: - Initializer
    
    //Full message
    internal init(messageText: String, receiverID: String, senderID: String, sentDate: Date, user: User? = nil) {
        self.messageText = messageText
        self.receiverID = receiverID
        self.senderID = senderID
        self.sentDate = sentDate
        self.user = user
        self.messageID = UUID().uuidString
    }
    
    internal init(dictionary: [String: Any]) {
        
        let data = dictionary
        
        if let messageText = data["messageText"] as? String {
            self.messageText = messageText
        } else {
            self.messageText = "Error @messageText"
        }
        
        if let receiverID = data["receiverID"] as? String {
            self.receiverID = receiverID
        } else {
            self.receiverID = "Error @receiverID"
        }
        
        if let senderID = data["senderID"] as? String {
            self.senderID = senderID
        } else {
            self.senderID = "Error @senderID"
        }
        
        if let sentDate = data["sentDate"] as? Timestamp {
            let date = sentDate.dateValue()
            self.sentDate = date
        } else {
            self.sentDate = Date()
        }
        
        if let messageID = data["messageID"] as? String {
            self.messageID = messageID
        } else {
            self.messageID = UUID().uuidString
        }
    }
    
    //MARK: - Firebase Initializer
    
    ///Initializer for Firebase
    init?(document: QueryDocumentSnapshot) {

        let data = document.data()

        if let messageText = data["messageText"] as? String {
            self.messageText = messageText
        } else {
            self.messageText = "Error @messageText"
        }
        
        if let receiverID = data["receiverID"] as? String {
            self.receiverID = receiverID
        } else {
            self.receiverID = "Error @receiverID"
        }
        
        if let senderID = data["senderID"] as? String {
            self.senderID = senderID
        } else {
            self.senderID = "Error @senderID"
        }
        
        if let sentDate = data["sentDate"] as? Timestamp {
            let date = sentDate.dateValue()
            self.sentDate = date
        } else {
            self.sentDate = Date()
        }
        
        if let messageID = data["messageID"] as? String {
            self.messageID = messageID
        } else {
            self.messageID = UUID().uuidString
        }
    }
}

//MARK: - DataRepresentation

extension Message: DataRepresentation {
    
    var representation: [String : Any] {
        let rep = ["messageText": messageText, "receiverID": receiverID, "senderID": senderID, "sentDate": sentDate, "messageID": messageID] as [String : Any]
        
        return rep
    }
}

//MARK: - Equatable

extension Message: Equatable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageID == rhs.messageID
    }
}
