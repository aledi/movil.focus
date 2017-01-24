//
//  ProfileViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 30/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import MessageUI

enum Sections: Int {
    case user
    case panels
    case help
    case other
    case logOut
}

let phoneNumber: String = "+528183387258"
let email: String = "atencion@focuscg.com.mx"

class ProfileViewController: UITableViewController, UIActivityItemSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var panelsLabel: UILabel!
    @IBOutlet var encuestasLabel: UILabel!
    
    var loadingAlert: UIAlertController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = User.currentUser, let paneles = self.appDelegate.paneles else {
            return
        }
        
        var pending = 0
        var active = 0
        
        for panel in paneles {
            active += panel.estado == .accepted ? 1 : 0
            pending += panel.encuestasPendientes
        }
        
        self.nameLabel.text = user.nombre
        self.emailLabel.text = user.email
        self.panelsLabel.text = "\(active)"
        self.encuestasLabel.text = "\(pending)"
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Navigation
    // -----------------------------------------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "logOut") {
            UserDefaults.removeUserDefaults()
            self.appDelegate.user = nil
        } else if (segue.identifier == "showHistorial") {
            let historialViewController = segue.destination as! HistorialViewController
            historialViewController.data = sender as! [Historial]
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Sections(rawValue: indexPath.section)! {
        case .panels:
            if (indexPath.row == 2) {
                self.downloadHistory()
            }
        case .help:
            if (indexPath.row == 1) {
                self.sendEmail()
            } else if (indexPath.row == 2) {
                self.call()
            }
            
            return
        case .other:
            if (indexPath.row == 0) {
                self.shareApp()
            } else if (indexPath.row == 1) {
                self.rateApp()
            }
        case .logOut:
            func firstBlock(_ action: UIAlertAction) {
                Controller.request(for: .unregisterDevice, withParameters: ["id" : User.currentUser!.id], withSuccessHandler: nil, andErrorHandler: nil)
                self.performSegue(withIdentifier: "logOut", sender: nil)
            }
            
            self.presentAlertWithTitle("Cerrar Sesión", withMessage: "La próxima vez que abra la aplicación se le pedirán sus datos de acceso.", withButtonTitles: ["Cancelar", "Cerrar"], withButtonStyles: [.cancel, .destructive], andButtonHandlers: [nil, firstBlock])
            
            return
        default:
            return
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Helpers
    // -----------------------------------------------------------------------------------------------------------
    
    func call() {
        if let phoneURL: URL = URL(string: "tel://\(phoneNumber)") {
            if (UIApplication.shared.canOpenURL(phoneURL)) {
                UIApplication.shared.openURL(phoneURL)
            }
        }
    }
    
    func sendEmail() {
        let mailComposeViewController = self.mailComposerViewController()
        
        if (MFMailComposeViewController.canSendMail()) {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        self.presentAlertWithTitle("Error", withMessage: "Su dispositivo parece no estar configurado para enviar correo.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
    }
    
    func mailComposerViewController() -> MFMailComposeViewController {
        let user = self.appDelegate.user!
        let mailComposerViewController = MFMailComposeViewController()
        
        mailComposerViewController.mailComposeDelegate = self
        mailComposerViewController.setToRecipients([email])
        mailComposerViewController.setSubject("Soporte Aplicación Móvil")
        mailComposerViewController.setMessageBody("\n\n\n\nUsuario: \(user.username)\nID: \(user.id)\nCorreo: \(user.email)", isHTML: false)
        
        return mailComposerViewController
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - History
    // -----------------------------------------------------------------------------------------------------------
    
    func downloadHistory() {
        self.loadingAlert = self.presentAlertWithTitle("Cargando", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
        Controller.request(for: .getHistory, withParameters: ["panelista" : "\(User.currentUser!.id)"], withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(_ response: NSDictionary) {
        self.loadingAlert?.dismiss(animated: true, completion: {
            var data: [Historial] = []
            
            if (response["status"] as? String == "SUCCESS") {
                if let results = response["results"] as? [AnyObject] {
                    for object in results {
                        let history = object as! NSDictionary
                        data.append(Historial(nombrePanel: history["nombrePanel"] as! String, fechaIniPanel: history["fechaInicioPanel"] as? String, fechaFinPanel: history["fechaFinPanel"] as? String, nombreEncuesta: history["nombreEncuesta"] as! String, fechaIniEncuesta: history["fechaInicioEncuesta"] as? String, fechaFinEncuesta: history["fechaFinEncuesta"] as? String, fechaRespuesta: history["fechaRespuesta"] as? String, horaRespuesta: history["horaRespuesta"] as? String))
                    }
                    
                    self.performSegue(withIdentifier: "showHistorial", sender: data)
                    return
                }
            }
            
            self.presentAlertWithTitle("Error", withMessage: "No hemos podido cargar los datos.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
        })
    }
    
    func errorHandler(_ response: NSDictionary) {
        self.loadingAlert?.dismiss(animated: true, completion: {
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
            
            self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
            print(response["error"] ?? "")
        })
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - MFMailComposeViewControllerDelegate
    // -----------------------------------------------------------------------------------------------------------
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Share/Rate App
    // -----------------------------------------------------------------------------------------------------------
    
    func shareApp() {
        let activityController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        if #available(iOS 9.0, *) {
            let excludedActivityTypes = [
                UIActivityType.print,
                UIActivityType.copyToPasteboard,
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.addToReadingList,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo,
                UIActivityType.openInIBooks
            ]
            
            activityController.excludedActivityTypes = excludedActivityTypes
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        return "¡Dale un vistazo a la aplicación de Focus!\n\nhttps://itunes.apple.com/us/app/focus/id1156729510?ls=1&mt=8"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "Focus"
    }
    
    func rateApp() {
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id1156729510")!)
    }
    
}
