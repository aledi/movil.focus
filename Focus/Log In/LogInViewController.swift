//
//  LogInViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var feedbackLabel: UILabel!
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Keyboard
    // -----------------------------------------------------------------------------------------------------------
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if (view.frame.origin.y == 0) {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if (view.frame.origin.y != 0) {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.tag == 10) {
            self.passwordText.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.logIn()
        }
        
        return false
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func cancelRegistration(segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
    }
    
    @IBAction func doneRegistration(segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
        
        self.usernameText.text = "Carlos"
        self.passwordText.text = "pass"
        
        self.logIn()
    }
    
    @IBAction func logInAttempt(sender: AnyObject) {
        self.logIn()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - LogIn
    // -----------------------------------------------------------------------------------------------------------
    
    func logIn() {
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
