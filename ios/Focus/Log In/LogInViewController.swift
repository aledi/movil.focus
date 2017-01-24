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
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Keyboard
    // -----------------------------------------------------------------------------------------------------------
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func keyboardDidShow(_ notification: Notification) {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 10, right: 0.0)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 10, right: 0.0)
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    @IBAction func cancelPasswordForgot(_ segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
    }
    
    @IBAction func cancelRegistration(_ segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
    }
    
    @IBAction func doneRegistration(_ segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
        
        self.usernameText.text = "Carlos"
        self.passwordText.text = "pass"
        
        self.logIn()
    }
    
    @IBAction func logInAttempt(_ sender: AnyObject) {
        self.logIn()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - LogIn
    // -----------------------------------------------------------------------------------------------------------
    
    func logIn() {
        let parameters: [String : Any] = [
            "username" : self.usernameText.text!,
            "password" : self.passwordText.text!
        ]
        
        self.spinner.startAnimating()
        
        Controller.request(for: .logIn, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(_ response: NSDictionary) {
        if (response["status"] as? String == "SUCCESS") {
            if let id = response["id"] as? Int, let username = response["username"] as? String, let email = response["email"] as? String, let nombre = response["nombre"] as? String, let genero = response["genero"] as? Int {
                let user = User(id: id, username: username, email: email, nombre: nombre, genero: genero)
                User.saveUser(user)
                
                if let user = User.currentUser {
                    UserDefaults.saveUserDefaults(user)
                }
            }
            
            var paneles: [Panel] = []
            if let panels = response["paneles"] as? [AnyObject] {
                for object in panels {
                    let panel = object as! NSDictionary
                    let newPanel = Panel(id: panel["id"] as! Int, nombre: panel["nombre"] as! String, descripcion: panel["descripcion"] as! String, fechaInicio: panel["fechaInicio"] as! String, fechaFin: panel["fechaFin"] as! String, estado: panel["estado"] as! Int)
                    
                    var encuestas: [Encuesta] = []
                    
                    for object2 in panel["encuestas"] as! [AnyObject] {
                        let survey = object2 as! NSDictionary
                        let newSurvey = Encuesta(id: survey["id"] as! Int, nombre: survey["nombre"] as! String, fechaInicio: survey["fechaInicio"] as! String, fechaFin: survey["fechaFin"] as! String, contestada: survey["contestada"] as! Bool)
                        
                        var preguntas: [Pregunta] = []
                        
                        for object3 in survey["preguntas"] as! [AnyObject] {
                            let question = object3 as! NSDictionary
                            let newQuestion = Pregunta(id: question["id"] as! Int, tipo: question["tipo"] as! Int, numPregunta: question["numPregunta"] as! Int, asCombo: question["combo"] as! Bool, titulo: question["titulo"] as! String, pregunta: question["pregunta"] as! String, video: question["video"] as! String, imagen: question["imagen"] as! String, opciones: question["opciones"] as! [String], subPreguntas: question["subPreguntas"] as! [String])
                            
                            preguntas.append(newQuestion)
                        }
                        
                        newSurvey.preguntas = preguntas
                        encuestas.append(newSurvey)
                    }
                    
                    newPanel.encuestas = encuestas
                    paneles.append(newPanel)
                }
                
                self.appDelegate.paneles = paneles
            }
            
            self.appDelegate.registerForNotifications()
            self.spinner.stopAnimating()
            self.performSegue(withIdentifier: "logIn", sender: self)
        } else {
            self.presentAlertWithTitle("Usuario o contraseña incorrectos", withMessage: "Verifique su usuario y contraseña", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
        }
        
        self.spinner.stopAnimating()
    }
    
    func errorHandler(_ response: NSDictionary) {
        self.spinner.stopAnimating()
        var alertTitle = ""
        var alertMessage = ""
        
        switch (response["error"] as! NSError).code {
        case -1009:
            alertTitle = "Sin conexión a internet"
            alertMessage = "Para utilizar la aplicación, su dispositivo debe estar conectado a internet."
        default:
            alertTitle = "Servidor no disponible"
            alertMessage = "Nuestro servidor no está disponible por el momento."
        }
        
        func firstBlock(_ action: UIAlertAction) {
            self.logIn()
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.default, .cancel], andButtonHandlers: [firstBlock, nil])
        print(response["error"] ?? "")
    }
    
}
