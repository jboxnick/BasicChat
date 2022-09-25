//
//  ConversationsViewController.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
    //MARK: - Outlets
    
    private let tableView = UITableView()

    
    private let newMessageButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.backgroundColor = .systemPurple
            button.tintColor = .white
            button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(nil, action: #selector(newMessageButtonTapped), for: .touchUpInside)
            return button
        }()
    
    //MARK: - Properties
    
    
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alertController = UIAlertController(title: "UserInfo bearbeiten", message: nil, preferredStyle: .alert)
                
                alertController.addTextField(configurationHandler: { textField in
                    textField.placeholder = "username"
                })
        
        alertController.addTextField(configurationHandler: { textField in
                            textField.placeholder = "email"
                        })
        
        
                let saveAction = UIAlertAction(title: "Sichern", style: .default) { action in
                    let firstTextField = alertController.textFields![0] as UITextField
                    guard let firstText = firstTextField.text else { return }
                    let secondTextField = alertController.textFields![1] as UITextField
                    guard let secondText = secondTextField.text else { return }
                    
                    let newUser = User(userID: Auth.auth().currentUser?.uid ?? UUID().uuidString, username: firstText, emailAdress: secondText)
                    
                           
                    Firestore.firestore().add(user: newUser) {}
                    
                    
                    
                    
                    
                    
                    
                    
                }
                let cancelAction = UIAlertAction(title: "Abbruch", style: .default, handler: nil)
                
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Setup Functions
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        ///NewMesaage Button hinzufügen zur View
        view.addSubview(tableView)

        tableView.addSubview(newMessageButton)
        
        ///TableView hinzufügen zur View
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    private func setupTableView() {
        
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: Constants.TableView.conversationTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
    }
    
    private func setupObservers() {
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.insertRows(_:)), name: NSNotification.Name(rawValue: "insertRows"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.reloadRows(_:)), name: NSNotification.Name(rawValue: "reloadRows"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.deleteRows(_:)), name: NSNotification.Name(rawValue: "deleteRows"), object: nil)
        }
    
    //MARK: - Helper Functions
    
    //MARK: - @objc Functions
        
        @objc func insertRows(_ notification: NSNotification) {
            print(#function)
            
            guard notification.userInfo?["identifier"] as? String == "conversations" else { return }
            
            if let index = notification.userInfo?["index"] as? Int {
                if let section = notification.userInfo?["section"] as? Int {
                    self.tableView.insertRows(at: [IndexPath(row: index, section: section)], with: .fade)
                  }
              }
        }
        
        @objc func reloadRows(_ notification: NSNotification) {
            print(#function)
            
            guard notification.userInfo?["identifier"] as? String == "conversations" else { return }
            
            if let index = notification.userInfo?["index"] as? Int {
                if let section = notification.userInfo?["section"] as? Int {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: section)], with: .fade)
                  }
              }
        }
        
        @objc func deleteRows(_ notification: NSNotification) {
            print(#function)
            
            guard notification.userInfo?["identifier"] as? String == "conversations" else { return }
            
            if let index = notification.userInfo?["index"] as? Int {
                if let section = notification.userInfo?["section"] as? Int {
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: section)], with: .fade)
                  }
              }
        }
    
    @objc func newMessageButtonTapped() {
        
        let destinationVC = NewMessageViewController()
        destinationVC.delegate = self
        
        self.navigationController?.pushViewController(destinationVC, animated: false)
    }
}

//MARK: - UITableViewDataSource + UITableViewDelegate

extension ConversationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ConversationSystem.shared.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.conversationTableViewCell, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 5

        cell.layer.shadowOpacity = 0.40
        cell.layer.masksToBounds = false
        cell.clipsToBounds = false
        
        let conversation = ConversationSystem.shared.conversations[indexPath.row]
        
        cell.conversation = conversation
        
        return cell
        
        
//        let lastMessageText = lastMessage?.messageText
//        
//        let messageSender = lastMessage?.senderID ?? UUID().uuidString
//        
//        if messageSender == Auth.auth().currentUser?.uid {
//            //letzte message war ich
//        } else {
//            //letzte message von gesprächspartner
//        }
//        
//        let participantCount = conversation.users.count
        
//        if lastMessage?.messageIsReadFrom.count ?? 0 > participantCount { //alle teilnehmer haben die nachricht gelesen
//            
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

//MARK: -

extension ConversationsViewController: NewMessageViewControllerDelegate {
    
    func controller(wantsToStartChatWith user: User) {
        //
        print("Will mit user Chatten: \(user)")
    }
}
