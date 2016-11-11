//
//  ChangePasswordViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 10/11/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController {

    @IBOutlet var oldPasswordText: UITextField!
    @IBOutlet var newPasswordText: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    var loadingAlert: UIAlertController?
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldPasswordText.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Change Password
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func changePassword(sender: AnyObject?) {
        self.dismissKeyboard()
        
        var alertMessage = ""
        
        if (self.oldPasswordText.text == nil || self.oldPasswordText.text!.isEmpty) {
            alertMessage = "Por favor, ingrese su contraseña actual."
        } else if (self.newPasswordText.text == nil || self.newPasswordText.text!.isEmpty) {
            alertMessage = "Por favor, ingrese una nueva contraseña."
        } else if (self.confirmPasswordField.text != self.newPasswordText.text) {
            alertMessage = "Los campos de nueva contraseña no coinciden."
        }
        
        if (!alertMessage.isEmpty) {
            self.presentAlertWithTitle("Campos Requeridos", withMessage: alertMessage, withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
            return
        }
        
        let parameters: [String : AnyObject] = [
            "panelista" : User.currentUser!.id,
            "old" : self.oldPasswordText.text!,
            "new" : self.newPasswordText.text!
        ]
        
        self.loadingAlert = self.presentAlertWithTitle("Espere, por favor...", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
        Controller.requestForAction(.CHANGE_PASSWORD, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        self.loadingAlert?.dismissViewControllerAnimated(false, completion: { 
            guard let status = response["status"] as? String else {
                return
            }
            
            var alertTitle = ""
            var alertMessage = ""
            
            if (status == "SUCCESS") {
                alertTitle = "Contraseña Guardada"
                alertMessage = "Su nueva contraseña ha sido guardada. A partir de este momento, utilícela para iniciar sesión en la aplicación."
                self.cleanFields()
            } else if (status == "WRONG_PASSWORD") {
                alertTitle = "Contraseña Incorrecta"
                alertMessage = "Su contraseña actual no coincide con nuestros registros."
            } else {
                alertTitle = "Error"
                alertMessage = "Hubo un error al intentar cambiar su contraseña. Por favor, intente más tarde o póngase en contacto con el servicio de soporte."
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
                self.changePassword(nil)
            }
            
            self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.Default, .Cancel], andButtonHandlers: [firstBlock, nil])
            print(response["error"])
        })
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Helpers
    // -----------------------------------------------------------------------------------------------------------
    
    func dismissKeyboard() {
        self.oldPasswordText.resignFirstResponder()
        self.newPasswordText.resignFirstResponder()
        self.confirmPasswordField.resignFirstResponder()
    }
    
    func cleanFields() {
        self.oldPasswordText.text = nil
        self.newPasswordText.text = nil
        self.confirmPasswordField.text = nil
    }
    
}
