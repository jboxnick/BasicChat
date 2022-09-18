//
//  AppController.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import UIKit
//import FirebaseAuth
//import FirebaseFirestore

final class AppController {
    
    //MARK: - Properties
    
    static let shared = AppController()
    
    private var window: UIWindow!
    
    var rootViewController: UIViewController? {
        didSet {
            if let vc = rootViewController {
                window.rootViewController = vc
            }
        }
    }
    
    //MARK: - Initializer
    
    init() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(userDefaultsDidChange),
                                       name: UserDefaults.didChangeNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(contextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(contextWillSave(_:)),
                                       name: Notification.Name.NSManagedObjectContextWillSave, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(contextDidSave(_:)),
                                       name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func showInitialView(window: UIWindow?) {
        
        guard let window = window else { return }
        
        self.window = window
        window.backgroundColor = .white
        
        updateRootVC()
        
        window.makeKeyAndVisible()
    }
    
    func updateRootVC() {
        
        var rootVC : UIViewController?
        rootVC = MainTabBarController()
        self.rootViewController = rootVC
    }
    
    // MARK: - Notifications
    
    @objc internal func userDefaultsDidChange() {
        print(#function)
    }
    
    @objc internal func contextObjectsDidChange(_ notification: Notification) {
        print(#function)
    }
    
    @objc internal func contextWillSave(_ notification: Notification) {
        print(#function)
    }
    
    @objc internal func contextDidSave(_ notification: Notification) {
        print(#function)
    }
    
    //MARK: - Navigation
    
    deinit {
        print("Deinitialisiert: \(self)")
    }
}
