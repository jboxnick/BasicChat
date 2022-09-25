//
//  AppController.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

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
        
        Auth.auth().signInAnonymously { authresult, error in
            
            if let err = error {
                UserDefaults.standard.set(false, forKey: "loginState")
                print(err.localizedDescription)
                self.updateRootVC()
                return
            }
            
            UserDefaults.standard.set(true, forKey: "loginState")
            let userID = authresult!.user.uid
            Database.database(url: Constants.Firebase.databaseURL).reference().child("user_sessions").updateChildValues([userID : true])
            print("Der User mit der UID: \(authresult!.user.uid) ist erfolgreich eingeloggt")
            
            let currentDate = Date()
            UserDefaults.standard.set(currentDate, forKey: "lastActiveDate")
            print("Saved \(currentDate) for key: lastActiveDate")
            Firestore.firestore().users.document(authresult!.user.uid).updateData(["lastActiveDate" : currentDate])
            
            self.updateRootVC()
            
            window.makeKeyAndVisible()
        }
    }
    
    func updateRootVC() {
        
        let userDefaults = UserDefaults.standard
        
        let status = userDefaults.bool(forKey: "loginState")
        var rootVC : UIViewController?
        
        if(status == true) {
            
            guard let userID = Auth.auth().currentUser?.uid else {
                
                AuthenticationService.logoutUser()
                return
            }
            
            // There is an user logged in
            // Check whether the user is saved to UserDefaults
            do {
                let user = try userDefaults.getObject(forKey: userID, castTo: User.self)
                UserSystem.shared.user = user
                print("The user was loaded out of UserDefaults.")
            } catch {
                print(error.localizedDescription)
                UserSystem.shared.getCurrentUser { user in
                    print("The user was downloaded: \(user)")
                    UserSystem.shared.user = user
                    do {
                        try userDefaults.setObject(user, forKey: userID)
                        print("User was added to UserDefaults.")
                    } catch {
                        print(error.localizedDescription)
                        print("Not able to add the user to UserDefaults.")
                    }
                }
            }
            rootVC = MainTabBarController()
            
            // Register for push notifications
            
//            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//
//            let pushManager = PushNotificationManager(userID: currentUserID)
//            pushManager.registerForPushNotifications()
            
        } else {
            
            // There is currently no user logged in
            UserSystem.shared.removeAllObservers()
            ConversationSystem.shared.removeAllObservers()
            
            rootVC = UINavigationController(rootViewController: UIViewController())
        }
        self.rootViewController = rootVC
    }
    
    // MARK: - Notifications
    
    @objc internal func userDefaultsDidChange() {}
    
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
