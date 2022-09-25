//
//  UserTableViewCell.swift
//  BasicChat
//
//  Created by Julian Boxnick on 25.09.22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    private let profilePictureImageView: UIImageView = {
            let iv = UIImageView()
            iv.backgroundColor = .lightGray
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            return iv
        }()
        
        private let usernameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            //label.text = "Speidermann"
            return label
        }()
        
        private let fullnameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .lightGray
            return label
        }()
    
    //MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    //MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        ///ProfilImageView hinzufügen
        addSubview(profilePictureImageView)
        profilePictureImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12) ///Zentriert das Bild Vertigal in der Mitte
        profilePictureImageView.setDimensions(height: 56, width: 56)
        profilePictureImageView.layer.cornerRadius = 56 / 2
        
        
        //StackView für die Labels
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profilePictureImageView, leftAnchor: profilePictureImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Functions
    
    func configure() {
        
        guard let user = user else { return }
                
        usernameLabel.text = user.username
        profilePictureImageView.image = UIImage(named: "user_placeholder")
        
        ///Profilbild übergeben vom jeweilgen User
//        guard let url = URL(string: user.profilImageUrl) else { return }
//        profileImageView.sd_setImage(with: url)
    }
}
