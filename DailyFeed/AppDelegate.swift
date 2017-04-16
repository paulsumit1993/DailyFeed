//
//  AppDelegate.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit
import RealmSwift
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //BuddyBuild Setup
        BuddyBuildSDK.setup()
        
        //Realm Shared DB Setup
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.trianz.DailyFeed.today")
        let realmURL = container?.appendingPathComponent("db.realm")
        var config = Realm.Configuration()
        config.fileURL = realmURL
        config.schemaVersion = 3
        config.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 3) {
                
            }
        }
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
        
        window?.tintColor = .black
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {

    }
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
                let tabBarController = window?.rootViewController as? UITabBarController,
                let bookmarkController = tabBarController.viewControllers?.last as? BookmarkViewController {
                    let uniqueIdentifierInteger = Int(uniqueIdentifier)!
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let newsDetailViewController = sb.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
                    let realm = try! Realm()
                    newsDetailViewController.receivedNewsItem = realm.objects(DailyFeedRealmModel.self)[uniqueIdentifierInteger]
                    newsDetailViewController.receivedItemNumber = uniqueIdentifierInteger
                    self.window?.rootViewController = tabBarController
                    tabBarController.selectedViewController = bookmarkController
                    let indexpath = IndexPath(item: uniqueIdentifierInteger, section: 0)
                    bookmarkController.collectionView(bookmarkController.bookmarkCollectionView, didSelectItemAt: indexpath)
                    self.window?.makeKeyAndVisible()
                }
        }
        return true
    }
}
