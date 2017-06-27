//
//  AppDelegate.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseCrashReporting
import Appsee


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    
    

    var submitReport:Bool = false
    
    var initprofile : Int = 0
    ///ReportTmp data
    var medallionNo:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var latitude2:String = ""
    var longitude2:String = ""
    var timeofreport:NSDate = NSDate()
    var selectedReport:Int = 0
    var typeofcomplaint:String = ""
    var typeofcomplaintColor:UIColor?
    var reportDescription:String = ""
    var passenger:Bool = true
    var videoData:NSURL?
    var audioData:NSURL?
    var photoData:UIImage?
    var colorOfTaxi : String = ""
   
    var selectedMenuItem : Int = 0   
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Enable Crash Reporting
        ParseCrashReporting.enable();
                       
        Parse.setApplicationId("jkAZF8ojV4vOGnhSBjdwiMWBKpWML5tM4SWGKgOV", clientKey: "wWRcFgATMmaUfNudUD4ZgWKDXo3hVgPkmZojrG7z")

        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //add push notification register
        let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        //
        
        Appsee.start("70f68b13429a49a187bd97b622d28d6d")
       
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("username")
        {
            let password = defaults.stringForKey("password")
            let email = defaults.stringForKey("email")
            
            print("Stored name & pwd & email \(name), \(password), \(email)")
        } else {
            
        }

//        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!
//        UINavigationBar.appearance().setBackgroundImage(barBackgroundImage, forBarMetrics: UIBarMetrics.Default)
        // Override point for customization after application launch.
        return true
        
       
    }
    
    //install push function
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        
        let installation = PFInstallation.currentInstallation()

//        let mUser = PFUser.currentUser()

        installation.addUniqueObject("Status", forKey: "channels")
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        
//        let pushQuery = PFQuery(className: "submission")
////      pushQuery.whereKey("Phone", equalTo: mUser.objectForKey("Phone"))
//        pushQuery.whereKey("status", equalTo: "1")
//        
//        // Send push notification to query
//        let push = PFPush()
//        push.setQuery(pushQuery) // Set our Installation query
//        push.setMessage("Test One Message Here")
//        push.sendPushInBackground()
        
        
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ios-blog.swiftLogin" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("swiftLogin", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("swiftLogin.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [NSObject : AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

