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
    @IBOutlet var genderText: UITextField!
    @IBOutlet var educationText: UITextField!
    
    @IBOutlet var streetText: UITextField!
    @IBOutlet var numberText: UITextField!
    @IBOutlet var coloniaText: UITextField!
    @IBOutlet var stateText: UITextField!
    @IBOutlet var cityText: UITextField!
    @IBOutlet var postalText: UITextField!
    
    @IBOutlet var sendButton: UIBarButtonItem!
    @IBOutlet var noDateButton: UIButton!
    
    var activeField: UITextField?
    
    var birthdayPicker = UIDatePicker()
    var genderPicker = UIPickerView()
    var educationPicker = UIPickerView()
    var statePicker = UIPickerView()
    var cityPicker = UIPickerView()
    
    let education: [(Int, String)] = [
        (0, "Nivel de Educación"),
        (1, "Primaria"),
        (2, "Secundaria"),
        (3, "Preparatoria"),
        (4, "Profesional"),
        (5, "Posgrado"),
        (6, "Ninguno")
    ]
    
    let gender: [(Int, String)] = [
        (-1, "-Sin especificar-"),
        (0, "Hombre"),
        (1, "Mujer")
    ]
    
    var states = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.fetchEstados()
        self.configurePickers()
    }
    
    func fetchEstados() {
        if let path = Bundle.main.path(forResource: "Estados", ofType: "plist") {
            self.states = NSArray(contentsOfFile: path) as! [[String : AnyObject]]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Pickers
    // -----------------------------------------------------------------------------------------------------------
    
    func configurePickers() {
        let calendar = Calendar.current
        
        self.birthdayPicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        self.birthdayPicker.datePickerMode = .date
        self.birthdayPicker.minimumDate = calendar.date(byAdding: .year, value: -100, to: Date())
        self.birthdayPicker.maximumDate = calendar.date(byAdding: .year, value: -18, to: Date())
        self.birthdayPicker.date = calendar.date(byAdding: .year, value: -21, to: Date())!
        self.birthdayText.inputView = self.birthdayPicker
        
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        self.genderText.inputView = self.genderPicker
        
        self.educationPicker.delegate = self
        self.educationPicker.dataSource = self
        self.educationText.inputView = self.educationPicker
        
        self.statePicker.delegate = self
        self.statePicker.dataSource = self
        self.stateText.inputView = self.statePicker
        
        self.cityPicker.delegate = self
        self.cityPicker.dataSource = self
        self.cityText.inputView = self.cityPicker
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        self.birthdayText.text = formatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == self.genderPicker) {
            return self.gender.count
        }
        
        if (pickerView == self.educationPicker) {
            return self.education.count
        }
        
        if (pickerView == self.statePicker) {
            return self.states.count
        }
        
        return self.municipiosForStateAtIndex(self.statePicker.selectedRow(inComponent: 0)).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == self.genderPicker) {
            return self.gender[row].1
        }
        
        if (pickerView == self.educationPicker) {
            return self.education[row].1
        }
        
        if (pickerView == self.statePicker) {
            return self.estadoAtIndex(row)
        }
        
        return self.municipiosForStateAtIndex(self.statePicker.selectedRow(inComponent: 0))[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == self.genderPicker) {
            self.genderText.text = (row > 0) ? self.gender[row].1 : nil
        } else if (pickerView == self.educationPicker) {
            self.educationText.text = (row > 0) ? self.education[row].1 : nil
        } else if (pickerView == self.statePicker) {
            self.stateText.text = (row > 0) ? self.estadoAtIndex(row) : nil
            self.cityPicker.selectRow(0, inComponent: 0, animated: false)
            self.cityText.text = nil
        } else {
            if (self.statePicker.selectedRow(inComponent: 0) == 0) {
                self.cityText.text = nil
                return
            }
            
            let municipios = self.municipiosForStateAtIndex(self.statePicker.selectedRow(inComponent: 0))
            self.cityText.text = municipios[row]
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Keyboard
    // -----------------------------------------------------------------------------------------------------------
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.birthdayText) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, YYYY"
            self.birthdayText.text = formatter.string(from: self.birthdayPicker.date)
        }
        
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
        (self.contentView.viewWithTag(textField.tag + 10) as! UITextField).becomeFirstResponder()
        return false
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    // -----------------------------------------------------------------------------------------------------------
   
    @IBAction func noDate(_ sender: AnyObject) {
        self.birthdayText.text = ""
        self.activeField?.resignFirstResponder()
    }
    
    @IBAction func registerAttempt(_ sender: AnyObject) {
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
        
//        if (self.birthdayText.text == nil || self.birthdayText.text!.isEmpty) {
//            return self.missingDataAlert(self.birthdayText)
//        }
//
//        if (self.genderText.text == nil || self.genderText.text!.isEmpty) {
//            return self.missingDataAlert(self.genderText)
//        }

        if (self.educationText.text == nil || self.educationText.text!.isEmpty) {
            return self.missingDataAlert(self.educationText)
        }
        
//        if (self.streetText.text == nil || self.streetText.text!.isEmpty) {
//            return self.missingDataAlert(self.streetText)
//        }
//        
//        if (self.numberText.text == nil || self.numberText.text!.isEmpty) {
//            return self.missingDataAlert(self.numberText)
//        }
//        
//        if (self.coloniaText.text == nil || self.coloniaText.text!.isEmpty) {
//            return self.missingDataAlert(self.coloniaText)
//        }
//        
//        if (self.cityText.text == nil || self.cityText.text!.isEmpty) {
//            return self.missingDataAlert(self.cityText)
//        }
//        
//        if (self.stateText.text == nil || self.stateText.text!.isEmpty) {
//            return self.missingDataAlert(self.stateText)
//        }
//        
//        if (self.postalText.text == nil || self.postalText.text!.isEmpty) {
//            return self.missingDataAlert(self.postalText)
//        }
        
        self.register()
    }
    
    func register() {
        self.enableInterface(false)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        var parameters: [String : Any] = [:]
        
        parameters["username"] = self.usernameText.text!
        parameters["password"] = self.passwordText.text!
        parameters["nombre"] = self.nameText.text!
        parameters["apellidos"] = self.lastnameText.text!
        parameters["email"] = self.emailText.text!
        parameters["genero"] = self.gender[self.genderPicker.selectedRow(inComponent: 0)].0
        parameters["fechaNacimiento"] = (self.birthdayText.text == nil || self.birthdayText.text!.isEmpty) ? "" : formatter.string(from: self.birthdayPicker.date)
        parameters["educacion"] = self.education[self.educationPicker.selectedRow(inComponent: 0)].0
        parameters["calleNumero"] = "\(self.streetText.text ?? "") \(self.numberText.text ?? "")"
        parameters["colonia"] = self.coloniaText.text as AnyObject?? ?? ""
        parameters["estado"] = self.states[self.statePicker.selectedRow(inComponent: 0)]["abreviacion"] as! String
        parameters["municipio"] = self.cityText.text as AnyObject?? ?? ""
        parameters["cp"] = self.postalText.text as AnyObject?? ?? ""
        
        Controller.request(for: .registerUser, withParameters: parameters, withSuccessHandler: successHandler, andErrorHandler: errorHandler)
    }
    
    func saveUser(_ id: Int) {
        let user = User(id: id, username: self.usernameText.text!, email: self.emailText.text!, nombre: "\(self.nameText.text!) \(self.lastnameText.text!)", genero: self.gender[self.genderPicker.selectedRow(inComponent: 0)].0 <= 0 ? 0 : 1)
        User.saveUser(user)
        
        if let user = User.currentUser {
            UserDefaults.saveUserDefaults(user)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Handlers
    // -----------------------------------------------------------------------------------------------------------
    
    func successHandler(_ response: NSDictionary) {
        self.enableInterface(true)
        
        if (response["status"] as? String == "SUCCESS") {
            self.saveUser(response["id"] as! Int)
            self.appDelegate.paneles = []
            self.appDelegate.registerForNotifications()
            self.performSegue(withIdentifier: "welcome", sender: nil)
        } else if (response["status"] as? String == "USER_EXISTS") {
            self.userExistsAlert()
        } else {
            self.errorAlert()
        }
    }
    
    func errorHandler(_ response: NSDictionary) {
        self.enableInterface(true)
        
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
            self.register()
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.default, .cancel], andButtonHandlers: [firstBlock, nil])
        print(response["error"] ?? "")
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Alerts
    // -----------------------------------------------------------------------------------------------------------
    
    func missingDataAlert(_ input: UITextField) {
        func firstBlock(_ action: UIAlertAction) {
            input.becomeFirstResponder()
        }
        
        self.presentAlertWithTitle("Faltan Datos", withMessage: "Por favor, ingresa todos los datos obligatorios.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [firstBlock])
    }
    
    func userExistsAlert() {
        func firstBlock(_ action: UIAlertAction) {
            self.usernameText.becomeFirstResponder()
        }
        
        self.presentAlertWithTitle("Usuario Existente", withMessage: "El usuario que ingresó ya existe. Por favor, intente con otro usuario.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [firstBlock])
    }
    
    func errorAlert() {
        func firstBlock(_ action: UIAlertAction) {
            self.register()
        }
        
        self.presentAlertWithTitle("Error", withMessage: "Hubo un error al guardar su registro. Por favor, intente de nuevo o contáctenos para ayudarle.", withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.default, .cancel], andButtonHandlers: [firstBlock, nil])
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Helpers
    // -----------------------------------------------------------------------------------------------------------
    
    func estadoAtIndex(_ index: Int) -> String {
        return self.states[index]["estado"] as! String
    }
    
    func municipiosForStateAtIndex(_ index: Int) -> [String] {
        return self.states[index]["municipios"] as! [String]
    }
    
    func enableInterface(_ enabled: Bool) {
        self.usernameText.isEnabled = enabled
        self.passwordText.isEnabled = enabled
        self.nameText.isEnabled = enabled
        self.lastnameText.isEnabled = enabled
        self.emailText.isEnabled = enabled
        self.birthdayText.isEnabled = enabled
        self.genderText.isEnabled = enabled
        self.educationText.isEnabled = enabled
        self.streetText.isEnabled = enabled
        self.numberText.isEnabled = enabled
        self.coloniaText.isEnabled = enabled
        self.cityText.isEnabled = enabled
        self.stateText.isEnabled = enabled
        self.postalText.isEnabled = enabled
        self.noDateButton.isEnabled = enabled
        self.sendButton.isEnabled = enabled
    }
    
}
