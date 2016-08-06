//
//  LogInViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var feedbackLabel: UILabel!

    @IBAction func cancelRegistration(segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
    }
    
    @IBAction func doneRegistration(segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
        
        self.usernameText.text = "Carlos"
        self.passwordText.text = "pass"
        
        self.logInAttempt()
    }
    
    @IBAction func logIn(sender: AnyObject) {
        self.logInAttempt()
    }
    
    func logInAttempt() {
        let parameters: [String : AnyObject] = [
            "username" : self.usernameText.text!,
            "password" : self.passwordText.text!
        ]
        
        Controller.requestForAction(.LOG_IN, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        if (response["status"] as? String == "SUCCESS") {
            if let id = response["id"] as? Int, username = response["username"] as? String, email = response["email"] as? String, nombre = response["nombre"] as? String {
                let user = User(id: id, username: username, email: email, nombre: nombre)
                User.saveUser(user)
                
                if let user = User.currentUser {
                    NSUserDefaults.saveUserDefaults(user)
                }
            }
            
            self.performSegueWithIdentifier("logIn", sender: self)
        } else {
            self.feedbackLabel.hidden = false
            self.feedbackLabel.text = "Usuario o contraseña incorrectos"
        }
    }
    
    func errorHandler(response: NSDictionary) {
        self.feedbackLabel.hidden = false
        self.feedbackLabel.text = "Servidor No Disponible"
        
        print(response["error"])
    }
    
}
