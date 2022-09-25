//
//  NewMessageViewController.swift
//  BasicChat
//
//  Created by Julian Boxnick on 25.09.22.
//

import UIKit

protocol NewMessageViewControllerDelegate: AnyObject {
    
    func controller(wantsToStartChatWith user: User)
}

class NewMessageViewController: UITableViewController {
    
    //MARK: - Outlets
    
    private let searchController = UISearchController(searchResultsController: nil)

    
    //MARK: - Properties
        
    private var filteredUsers = [User]()
    
    weak var delegate: NewMessageViewControllerDelegate?
       
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupSearchController()
    }
    
    //MARK: - Setup Functions
    
    private func setupViews() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
    }
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: Constants.TableView.userTableViewCell)
        tableView.rowHeight = 80
    }
    
    func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        
        ///SearchbarColor
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
      }
    
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        
        ///Gehe wieder zurück zum vorhergende Controller
        ///
        ///
        ///
        ///
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
}
//MARK: - UITableViewDataSource + UITableViewDelegate

extension NewMessageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredUsers.count : UserSystem.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.userTableViewCell, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        cell.user =  inSearchMode ? filteredUsers[indexPath.row] : UserSystem.shared.users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let user = inSearchMode ? filteredUsers[indexPath.row] : UserSystem.shared.users[indexPath.row]
            delegate?.controller(wantsToStartChatWith: user)
        }
}

extension NewMessageViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        ///Updating the SearchResults / Filtering
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        print("DEBUG: SearchQuery is \(searchText)")
        
        //User filtern
        filteredUsers = UserSystem.shared.users.filter({ user -> Bool in
            return user.username.contains(searchText)
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
