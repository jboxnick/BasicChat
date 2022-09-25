//
//  ConversationSystem.swift
//  BasicChat
//
//  Created by Julian Boxnick on 24.09.22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class ConversationSystem {
    
    static let shared = ConversationSystem()
    
    //MARK: - Categories
    
    ///All article categories
    public var conversations = [Conversation]() {
        didSet {
            conversations.sort(by: { $0.lastModifiedDate > $1.lastModifiedDate })
        }
    }
    
    //MARK: - Firebase Database References
    
    ///The root reference to the FirebaseDatabase
    let databaseReference = Database.database(url: "https://basicchat-89e2d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    //MARK: - Firebase Firestore References
    
    ///The root reference to the FirebaseFirestore
    let firestoreReference = Firestore.firestore()
    
    //MARK: - Listener Registrations
    
    ///The listener for all the category documents stored inside FirebaseFirestore
    var allConversationsListener: ListenerRegistration?
    
    //MARK: - Helper Functions
    
    ///Remove all observers for FirebaseDatabase and FirebaseFirestore
    func removeAllObservers() {
        
        removeConversationsObserver()
    }
    
    //MARK: - General Category Query Functions
    
    ///Realtime listening for all conversations
    
    func addConversationsObserver(_ update: @escaping () -> Void) {
        
      //  guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        whereField("users", arrayContains: currentUserID).

        allConversationsListener = firestoreReference.conversations.addSnapshotListener { querySnapshot, error in

            guard let snapshot = querySnapshot else { return }

            snapshot.documentChanges.forEach { change in
                
                guard let conversation = Conversation(document: change.document) else { return }

                switch change.type {

                case .added:

                    self.addConversationToTable(conversation)

                case .modified:

                    self.updateConversationInTable(conversation)

                case .removed:

                    self.removeConversationFromTable(conversation)
                }
                update()
            }
        }
    }
    
    //MARK: - Conversations Table Functions
        
        private func addConversationToTable(_ conversation: Conversation) {
            
            let nc = NotificationCenter.default
                        
            guard !conversations.contains(conversation) else { return }
            
            conversations.append(conversation)
            
            guard let index = conversations.firstIndex(of: conversation) else { return }
            
            nc.post(name: Notification.Name("insertRows"), object: nil, userInfo: ["identifier": "conversations", "index" : index, "section": 0])
        }
        
        private func updateConversationInTable(_ conversation: Conversation) {
            
            let nc = NotificationCenter.default
            
            guard let index = conversations.firstIndex(of: conversation) else { return }
            
            conversations[index] = conversation
            
            nc.post(name: Notification.Name("reloadRows"), object: nil, userInfo: ["identifier": "conversations", "index" : index, "section": 0])
        }
        
        private func removeConversationFromTable(_ conversation: Conversation) {
            
            let nc = NotificationCenter.default
            
            guard let index = conversations.firstIndex(of: conversation) else { return }
            
            conversations.remove(at: index)
            
            nc.post(name: Notification.Name("deleteRows"), object: nil, userInfo: ["identifier": "conversations", "index" : index, "section": 0])
        }
    
    ///Stop listening for conversations
    func removeConversationsObserver() {
        
        allConversationsListener?.remove()
        conversations.removeAll()
    }
}
