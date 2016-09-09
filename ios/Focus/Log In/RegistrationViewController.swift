//
//  RegistrationViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }

    @IBAction func register(sender: AnyObject) {
        let user = User(id: 1, username: "Carlos", email: "carlosmay@hotmail.com", nombre: "Carlos Mayo Rodríguez", genero: 0)
        User.saveUser(user)
        
        if let user = User.currentUser {
            NSUserDefaults.saveUserDefaults(user)
        }
        
        self.appDelegate.paneles = []
        self.appDelegate.registerForPushNotifications()
        self.performSegueWithIdentifier("welcome", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
