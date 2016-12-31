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
        guard let _ = User.currentUser, _ = self.paneles else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            
            return
        }
        
        self.updateBadgeIcon()
        self.scheduleLocalNotifications()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        self.showStoryboard()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func showStoryboard() {
        guard let storedUser = NSUserDefaults.retreiveUserDefaults() else {
            return
        }
        
        self.user = storedUser
        
        if (self.user!.token == "") {
            self.registerForNotifications()
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func updateBadgeIcon() {
        var pending = 0
        
        for panel in self.paneles! {
            pending += panel.encuestasPendientes
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = pending
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Notifications
    // -----------------------------------------------------------------------------------------------------------
    
    func registerForNotifications() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleLocalNotifications() {
        for panel in self.paneles! {
            guard let encuestas = panel.encuestas else {
                continue
            }
            
            for encuesta in encuestas {
                if (!encuesta.contestada) {
                    let fireDate = encuesta.fechaFin.dateByAddingTimeInterval(60 * 60 * 24 * -3 + (60 * 60 * 10))
                    
                    if (fireDate.compare(NSDate()) == .OrderedDescending) {
                        let localNotification = UILocalNotification()
                        
                        localNotification.fireDate = fireDate
                        localNotification.alertTitle = "Encuesta Pendiente"
                        localNotification.alertBody = "Recuerda contestar la encuesta \"\(encuesta.nombre)\" antes de que cierre."
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    }
                }
            }
        }
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
