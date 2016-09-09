//
//  RegistrationViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    @IBOutlet var nameText: UITextField!
    @IBOutlet var lastnameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var birthdayText: UITextField!
    @IBOutlet var educationText: UITextField!
    
    @IBOutlet var maleButton: RadioButton!
    @IBOutlet var femaleButton: RadioButton!
    
    @IBOutlet var streetText: UITextField!
    @IBOutlet var numberText: UITextField!
    @IBOutlet var coloniaText: UITextField!
    @IBOutlet var cityText: UITextField!
    @IBOutlet var stateText: UITextField!
    @IBOutlet var postalText: UITextField!
    
    var activeField: UITextField?
    
    var birthdayPicker = UIDatePicker()
    var educationPicker = UIPickerView()
    var statePicker = UIPickerView()
    
    let states: [(String, String)] = [
        ("0", "Selecciona un estado"),
        ("AGS", "Aguascalientes"),
        ("BC", "Baja California"),
        ("BCS", "Baja California Sur"),
        ("CAMP", "Campeche"),
        ("COAH", "Coahuila"),
        ("COL", "Colima"),
        ("CHIS", "Chiapas"),
        ("CDMX", "Ciudad de México"),
        ("DGO", "Durango"),
        ("GTO", "Guanajuato"),
        ("GRO", "Guerrero"),
        ("HGO", "Hidalgo"),
        ("JAL", "Jalisco"),
        ("EDOMEX", "Estado de México"),
        ("MICH", "Michoacán"),
        ("MOR", "Morelos"),
        ("NAY", "Nayarit"),
        ("NL", "Nuevo León"),
        ("OAX", "Oaxaca"),
        ("PUE", "Puebla"),
        ("QRO", "Querétaro"),
        ("QROO", "Quintana Roo"),
        ("SLP", "San Luis Potosí"),
        ("SIN", "Sinaloa"),
        ("SON", "Sonora"),
        ("TAB", "Tabasco"),
        ("TAM", "Tamaulipas"),
        ("TLAX", "Tlaxcala"),
        ("VER", "Veracruz"),
        ("YUC", "Yucatan"),
        ("ZAC", "Zacatecas")
    ]
    
    let education: [(Int, String)] = [
        (0, "Nivel de Educación"),
        (1, "Primaria"),
        (2, "Secundaria"),
        (3, "Preparatoria"),
        (4, "Profesional"),
        (5, "Posgrado"),
        (6, "Ninguno")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.configurePickers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Pickers
    // -----------------------------------------------------------------------------------------------------------
    
    func configurePickers() {
        let calendar = NSCalendar.currentCalendar()
        
        self.birthdayPicker.addTarget(self, action: #selector(self.dateChanged(_:)), forControlEvents: .ValueChanged)
//        self.birthdayPicker.addTarget(self, action: #selector(self.datePickerDidShow(_:)), forControlEvents: .EditingDidBegin)
        self.birthdayPicker.datePickerMode = .Date
        self.birthdayPicker.minimumDate = calendar.dateByAddingUnit(.Year, value: -100, toDate: NSDate(), options: [])
        self.birthdayPicker.maximumDate = calendar.dateByAddingUnit(.Year, value: -18, toDate: NSDate(), options: [])
        self.birthdayText.inputView = self.birthdayPicker
        
        self.educationPicker.delegate = self
        self.educationPicker.dataSource = self
        self.educationText.inputView = self.educationPicker
        
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        self.stateText.inputView = self.statePicker
    }
    
//    func datePickerDidShow(sender: UIDatePicker) {
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "YYYY-MM-dd"
//        self.birthdayText.text = formatter.stringFromDate(sender.date)
//    }
    
    func dateChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        self.birthdayText.text = formatter.stringFromDate(sender.date)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerView == self.educationPicker) ? self.education.count : self.states.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerView == self.educationPicker) ? self.education[row].1 : self.states[row].1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == self.educationPicker) {
            self.educationText.text = (row > 0) ? self.education[row].1 : nil
        } else {
            self.stateText.text = (row > 0) ? self.states[row].1 : nil
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Keyboard
    // -----------------------------------------------------------------------------------------------------------
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 10, right: 0.0)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 10, right: 0.0)
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            
            if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        (self.contentView.viewWithTag(textField.tag + 10) as! UITextField).becomeFirstResponder()
        return false
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func gender(sender: RadioButton) {
        sender.selected = true
        
        if (sender == self.maleButton) {
            self.femaleButton.selected = false
        } else {
            self.maleButton.selected = false
        }
    }
    
    @IBAction func registerAttempt(sender: AnyObject) {
        if (self.usernameText.text == nil || self.usernameText.text!.isEmpty) {
            return self.missingDataAlert(self.usernameText)
        }
        
        if (self.passwordText.text == nil || self.passwordText.text!.isEmpty) {
            return self.missingDataAlert(self.passwordText)
        }
        
        if (self.nameText.text == nil || self.nameText.text!.isEmpty) {
            return self.missingDataAlert(self.nameText)
        }
        
        if (self.lastnameText.text == nil || self.lastnameText.text!.isEmpty) {
            return self.missingDataAlert(self.lastnameText)
        }
        
        if (self.emailText.text == nil || self.emailText.text!.isEmpty) {
            return self.missingDataAlert(self.emailText)
        }
        
        if (self.birthdayText.text == nil || self.birthdayText.text!.isEmpty) {
            return self.missingDataAlert(self.birthdayText)
        }
        
        if (self.educationText.text == nil || self.educationText.text!.isEmpty) {
            return self.missingDataAlert(self.educationText)
        }
        
        if (self.streetText.text == nil || self.streetText.text!.isEmpty) {
            return self.missingDataAlert(self.streetText)
        }
        
        if (self.numberText.text == nil || self.numberText.text!.isEmpty) {
            return self.missingDataAlert(self.numberText)
        }
        
        if (self.coloniaText.text == nil || self.coloniaText.text!.isEmpty) {
            return self.missingDataAlert(self.coloniaText)
        }
        
        if (self.cityText.text == nil || self.cityText.text!.isEmpty) {
            return self.missingDataAlert(self.cityText)
        }
        
        if (self.stateText.text == nil || self.stateText.text!.isEmpty) {
            return self.missingDataAlert(self.stateText)
        }
        
        if (self.postalText.text == nil || self.postalText.text!.isEmpty) {
            return self.missingDataAlert(self.postalText)
        }
        
        self.register()
    }
    
    func register() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let parameters: [String : AnyObject] = [
            "username" : self.usernameText.text!,
            "password" : self.passwordText.text!,
            "nombre" : self.nameText.text!,
            "apellidos" : self.lastnameText.text!,
            "email" : self.emailText.text!,
            "genero" : self.maleButton.selected ? 0 : 1,
            "fechaNacimiento" : formatter.stringFromDate(self.birthdayPicker.date),
            "educacion" : self.education[self.educationPicker.selectedRowInComponent(0)].0,
            "calleNumero" : "\(self.streetText.text!) \(self.numberText.text!)",
            "colonia" : self.coloniaText.text!,
            "municipio" : self.cityText.text!,
            "estado" : self.states[self.statePicker.selectedRowInComponent(0)].0,
            "cp" : self.postalText.text!
        ]
        
        Controller.requestForAction(.REGISTER_USER, withParameters: parameters, withSuccessHandler: successHandler, andErrorHandler: errorHandler)
    }
    
    func saveUser(id: Int) {
        let user = User(id: id, username: self.usernameText.text!, email: self.emailText.text!, nombre: "\(self.nameText.text!) \(self.lastnameText.text!)", genero: self.maleButton.selected ? 0 : 1)
        User.saveUser(user)
        
        if let user = User.currentUser {
            NSUserDefaults.saveUserDefaults(user)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Handlers
    // -----------------------------------------------------------------------------------------------------------
    
    func successHandler(response: NSDictionary) {
        if (response["status"] as? String == "SUCCESS") {
            self.saveUser(response["id"] as! Int)
            self.appDelegate.paneles = []
            self.appDelegate.registerForPushNotifications()
            self.performSegueWithIdentifier("welcome", sender: nil)
        } else if (response["status"] as? String == "USER_EXISTS") {
            self.userExistsAlert()
        } else {
            self.errorAlert()
        }
    }
    
    func errorHandler(response: NSDictionary) {
        var alertTitle = ""
        var alertMessage = ""
        
        switch (response["error"] as! NSError).code {
        case -1009:
            alertTitle = "Sin conexión a internet"
            alertMessage = "Para utilizar la aplicación, su dispositivo debe estar conectado a internet."
        case -1003:
            alertTitle = "Servidor no disponible"
            alertMessage = "Nuestro servidor no está disponible por el momento."
        default:
            break
        }
        
        func firstBlock(action: UIAlertAction) {
            self.register()
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.Default, .Cancel], andButtonHandlers: [firstBlock, nil])
        print(response["error"])
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Alerts
    // -----------------------------------------------------------------------------------------------------------
    
    func missingDataAlert(input: UITextField) {
        func firstBlock(action: UIAlertAction) {
            input.becomeFirstResponder()
        }
        
        self.presentAlertWithTitle("Faltan Datos", withMessage: "Por favor, ingresa todos los datos solicitados.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [firstBlock])
    }
    
    func userExistsAlert() {
        func firstBlock(action: UIAlertAction) {
            self.usernameText.becomeFirstResponder()
        }
        
        self.presentAlertWithTitle("Usuario Existente", withMessage: "El usuario que ingresó ya existe. Por favor, intente con otro usuario.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [firstBlock])
    }
    
    func errorAlert() {
        func firstBlock(action: UIAlertAction) {
            self.register()
        }
        
        self.presentAlertWithTitle("Error", withMessage: "Hubo un error al guardar su registro. Por favor, intente de nuevo o contáctenos para ayudarle.", withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.Default, .Cancel], andButtonHandlers: [firstBlock, nil])
    }
    
}
