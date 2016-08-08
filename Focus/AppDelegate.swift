//
//  AppDelegate.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

let phoneNumber: String = "+528183387258"
let email: String = "email@pending.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var user: User?
    var paneles: [Panel]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        guard let storedUser = NSUserDefaults.retreiveUserDefaults() else {
            return
        }
        
        self.user = storedUser
        self.registerForPushNotifications()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Push Notifications
    // -----------------------------------------------------------------------------------------------------------
    
    func registerForPushNotifications() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if (notificationSettings.types != .None) {
            application.registerForRemoteNotifications()
        } else {
            Controller.requestForAction(.UNREGISTER_DEVICE, withParameters: ["id" : User.currentUser!.id], withSuccessHandler: nil, andErrorHandler: nil)
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        let parameters: [String : AnyObject] = [
            "id" : User.currentUser!.id,
            "deviceToken" : tokenString,
            "deviceType" : 1
        ]
        
        Controller.requestForAction(.REGISTER_DEVICE, withParameters: parameters, withSuccessHandler: nil, andErrorHandler: nil)
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
}

