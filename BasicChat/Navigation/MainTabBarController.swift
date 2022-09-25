//
//  MainTabBarController.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    
    //MARK: - Initializer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBar.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        setupViews()
        delegate = self
                
        ConversationSystem.shared.addConversationsObserver {
            //
        }
        
        UserSystem.shared.addUserSessionListener { valid in
            //
        }
        
        UserSystem.shared.addCurrentUserListener {
            //
        }
        
        UserSystem.shared.addUsersObserver {
            //
        }
    }

    
    //MARK: - Setup Functions
    
    private func setupViews() {
        
        //First ViewController
        let firstVC = UINavigationController(rootViewController: ConversationsViewController())
        firstVC.navigationBar.tintColor = .black
        firstVC.navigationBar.prefersLargeTitles = true
        firstVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        firstVC.navigationBar.largeTitleTextAttributes = firstVC.navigationBar.titleTextAttributes
        let firstVCItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "bubble.left.and.bubble.right"), selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill"))
        firstVC.tabBarItem = firstVCItem
        
        let controllers = [firstVC]
        self.viewControllers = controllers
    }
    
    //MARK: - Navigation
    
    deinit {
        ConversationSystem.shared.removeAllObservers()
        print("Deinit complete: \(self)")
    }
}

//MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
