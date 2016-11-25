//
//  AppDelegate.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var user: User?
    var paneles: [Panel]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.showStoryboard()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        guard let _ = User.currentUser, paneles = self.paneles else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            return
        }
        
        var pending = 0
        
        for panel in paneles {
            pending += panel.encuestasPendientes
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = pending
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        self.showStoryboard()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func showStoryboard() {
        guard let storedUser = NSUserDefaults.retreiveUserDefaults() else {
            return
        }
        
        self.user = storedUser
        
        if (self.user!.token == "") {
            self.registerForPushNotifications()
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
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
        
        if (self.user!.token == "") {
            self.user!.token = tokenString
            Controller.requestForAction(.REGISTER_DEVICE, withParameters: parameters, withSuccessHandler: nil, andErrorHandler: nil)
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
}
