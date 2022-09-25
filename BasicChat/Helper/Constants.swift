//
//  Constants.swift
//  BasicChat
//
//  Created by Julian Boxnick on 24.09.22.
//

import UIKit
import FirebaseAuth

struct Constants {
    
    struct TableView {
        
        static let cell = "cell"
        static let conversationTableViewCell = "conversationTableViewCell"
        static let userTableViewCell = "userTableViewCell"
        
        
        
        
        static let pickerViewTableViewCell = "pickerViewTableViewCell"
        static let switchTableViewCell = "switchTableViewCell"
        static let textFieldTableViewCell = "textFieldTableViewCell"
        static let segmentedControlTableViewCell = "segmentedControlTableViewCell"
        static let materialTableViewCell = "materialTableViewCell"
        static let materialOptionSegmentedControlTableViewCell = "materialOptionSegmentedControlTableViewCell"
    }
    
    struct CollectionView {
        
        static let buttonCollectionViewCell = "buttonCollectionViewCell"
    }
    
    struct Firebase {
        
        static let conversationsCollection = "conversations"
        static let usersCollection = "users"
        
        static let databaseURL = "https://basicchat-89e2d-default-rtdb.europe-west1.firebasedatabase.app/"
    }
    
    struct Others {
        
        static let persistentCloudKitContainerName = "BasicChat"
        
        static let defaultProfilePictureURL = ""
    }
}
