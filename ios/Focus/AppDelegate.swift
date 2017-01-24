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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.showStoryboard()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let _ = User.currentUser, let _ = self.paneles else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            UIApplication.shared.cancelAllLocalNotifications()
            
            return
        }
        
        self.updateBadgeIcon()
        self.scheduleLocalNotifications()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.showStoryboard()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func showStoryboard() {
        guard let storedUser = UserDefaults.retreiveUserDefaults() else {
            return
        }
        
        self.user = storedUser
        
        if (self.user!.token == "") {
            self.registerForNotifications()
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func updateBadgeIcon() {
        var pending = 0
        
        for panel in self.paneles! {
            pending += panel.encuestasPendientes
        }
        
        UIApplication.shared.applicationIconBadgeNumber = pending
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Notifications
    // -----------------------------------------------------------------------------------------------------------
    
    func registerForNotifications() {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleLocalNotifications() {
        for panel in self.paneles! {
            guard let encuestas = panel.encuestas , panel.estado == .accepted else {
                continue
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            
            for encuesta in encuestas {
                if (!encuesta.contestada) {
                    let fireDate = encuesta.fechaFin.addingTimeInterval(-136800)
                    
                    if (fireDate.compare(Date()) == .orderedDescending) {
                        let localNotification = UILocalNotification()
                        
                        localNotification.fireDate = fireDate
                        localNotification.alertTitle = "Encuesta Pendiente"
                        localNotification.alertBody = "Recuerda contestar la encuesta \"\(encuesta.nombre)\" antes de \(dateFormatter.string(from: encuesta.fechaFin as Date))."
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        
                        UIApplication.shared.scheduleLocalNotification(localNotification)
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if (notificationSettings.types != UIUserNotificationType()) {
            application.registerForRemoteNotifications()
        } else {
            Controller.request(for: .unregisterDevice, withParameters: ["id" : User.currentUser!.id], withSuccessHandler: nil, andErrorHandler: nil)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        let parameters: [String : Any] = [
            "id" : User.currentUser!.id,
            "deviceToken" : tokenString,
            "deviceType" : 1
        ]
        
        if (self.user!.token == "") {
            self.user!.token = tokenString
            Controller.request(for: .registerDevice, withParameters: parameters, withSuccessHandler: nil, andErrorHandler: nil)
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
}
