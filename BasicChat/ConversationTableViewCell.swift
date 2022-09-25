//
//  ConversationTableViewCell.swift
//  BasicChat
//
//  Created by Julian Boxnick on 24.09.22.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    let profilePictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor  = .lightGray
        return iv
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Properties
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    //MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        ///Add labels
        
        addSubview(profilePictureImageView)
        profilePictureImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profilePictureImageView.setDimensions(height: 50, width: 50)
        profilePictureImageView.layer.cornerRadius = 50 / 2
        profilePictureImageView.centerY(inView: self)
        
        ///StackView
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profilePictureImageView)
        stack.anchor(left: profilePictureImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        
        guard let conversation = conversation else { return }
        
        usernameLabel.text = "Username"
        messageTextLabel.text = conversation.lastMessage.messageText

        timestampLabel.text = conversation.lastMessage.dateString
        profilePictureImageView.image = UIImage(named: "user_placeholder")
       // profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
