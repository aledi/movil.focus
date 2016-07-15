//
//  LogInViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var feedbackLabel: UILabel!

    @IBAction func logIn(sender: AnyObject) {
        let parameters: [String : AnyObject] = [
            "action" : "PANELISTA_LOG_IN",
            "email" : self.emailText.text!,
            "password" : self.passwordText.text!
        ]
        
        Controller.request(parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        if (response["status"] as? String == "SUCCESS") {
            if let id = response["id"] as? Int, email = response["email"] as? String, nombre = response["nombre"] as? String {
                let user = User(id: id, email: email, nombre: nombre)
                User.saveUser(user)
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
