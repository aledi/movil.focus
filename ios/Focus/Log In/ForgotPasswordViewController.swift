//
//  ForgotPasswordViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 15/11/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UITableViewController {

    @IBOutlet var userText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    var loadingAlert: UIAlertController?
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Recover Password
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func recoverPassword(sender: AnyObject?) {
        self.dismissKeyboard()
        
        if ((self.userText.text == nil || self.userText.text!.isEmpty) && (self.emailText.text == nil || self.emailText.text!.isEmpty)) {
            self.presentAlertWithTitle("Campos Requeridos", withMessage: "Por favor, ingrese su nombre de usuario o correo electrónico.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
            return
        }
        
        let parameters: [String : AnyObject] = [
            "username" : self.userText.text ?? "",
            "email" : self.emailText.text ?? ""
        ]
        
        self.loadingAlert = self.presentAlertWithTitle("Espere, por favor...", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
        Controller.requestForAction(.FORGOT_PASSWORD, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        self.loadingAlert?.dismissViewControllerAnimated(false, completion: {
            guard let status = response["status"] as? String else {
                return
            }
            
            var alertTitle = ""
            var alertMessage = ""
            
            if (status == "SUCCESS") {
                let email = response["email"] as! String
                
                alertTitle = "Contraseña Enviada"
                alertMessage = "Hemos enviado un correo a \(email) con su contraseña. Si usted no recibe el correo en pocos minutos, por favor revise su bandeja de correo SPAM."
                self.cleanFields()
            } else if (status == "WRONG_USER") {
                alertTitle = "Sin Registros"
                alertMessage = "No hemos encontrado un usuario registrado con los datos proporcionados. Por favor, verifique los datos."
            } else {
                alertTitle = "Error"
                alertMessage = "Hubo un error al enviar su petición. Por favor, intente más tarde o póngase en contacto con el servicio de soporte."
            }
            
            self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
        })
    }
    
    func errorHandler(response: NSDictionary) {
        self.loadingAlert?.dismissViewControllerAnimated(false, completion: {
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
            
            func firstBlock(action: UIAlertAction) {
                self.recoverPassword(nil)
            }
            
            self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.Default, .Cancel], andButtonHandlers: [firstBlock, nil])
            print(response["error"])
        })
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Helpers
    // -----------------------------------------------------------------------------------------------------------
    
    func dismissKeyboard() {
        self.userText.resignFirstResponder()
        self.emailText.resignFirstResponder()
    }
    
    func cleanFields() {
        self.userText.text = nil
        self.emailText.text = nil
    }
    
}
