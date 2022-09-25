//
//  AppDelegate.swift
//  BasicChat
//
//  Created by Julian Boxnick on 18.09.22.
//

import UIKit
import CoreData
import Firebase
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties
    
    ///The shared AppDelegate
    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    
    //MARK: - App Life Cyle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Configure Firebase
        FirebaseApp.configure()
        
        //Configure Kingfisher's Cache
        let cache = ImageCache.default
        
        //Constrain Memory Cache to 500 MB
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 500
        
        //Constrain Disk Cache to 1 GB
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1000
        
        //Memory storage expires after 10 minutes.
        cache.memoryStorage.config.expiration = .seconds(600)
        
        //Disk storage expires after 7 days.
        cache.diskStorage.config.expiration = .days(7)
        
        //Show Initial View
        AppController.shared.showInitialView(window: UIWindow(frame: UIScreen.main.bounds))
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        saveContext()
    }
    
    //MARK: - CoreData
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BasicChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

