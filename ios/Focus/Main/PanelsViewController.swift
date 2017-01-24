//
//  PanelsViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PanelsViewController: UITableViewController {
    
    var paneles: [Panel]?
    var selectedPanel: Panel?
    var selectedIndex = 0
    var selectedAction = 0
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
        
        self.paneles = self.appDelegate.paneles
        self.tableView.reloadData()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Navigation
    // -----------------------------------------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "showEncuestas") {
            (segue.destination as! EncuestasViewController).encuestas = (sender as! Panel).encuestas
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.paneles == nil || self.paneles!.count == 0) ? 1 : self.paneles!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.paneles == nil || self.paneles!.count == 0) ? 270 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.paneles == nil || self.paneles!.count == 0) {
            return tableView.dequeueReusableCell(withIdentifier: "noContentCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "panelCell", for: indexPath) as! PanelViewCell
        cell.configure(for: self.paneles![indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let panel = self.paneles![indexPath.row]
        
        self.selectedPanel = panel
        self.selectedIndex = indexPath.row
        
        if (panel.estado != .accepted) {
            self.presentAlertWithTitle("Invitación", withMessage: "\(panel.descripcion)\n\nAcepte la invitación para comenzar a participar.", withButtonTitles: ["Aceptar", "Rechazar", "Cancelar"], withButtonStyles: [.default, .destructive, .cancel], andButtonHandlers: [self.acceptInvitation, self.rejectInvitation, nil])
        } else if (panel.encuestas?.count == 0) {
            self.presentAlertWithTitle("No hay Encuestas", withMessage: "Este panel aún no cuenta con encuestas. Por favor, espere a que una encuesta sea habilitada.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
        } else {
            self.performSegue(withIdentifier: "showEncuestas", sender: panel)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Accept/Reject
    // -----------------------------------------------------------------------------------------------------------
    
    func acceptInvitation(_ action: UIAlertAction) {
        guard let panelistaId = User.currentUser?.id, let panelId = self.selectedPanel?.id else {
            return
        }
        
        self.acceptRejectCall(panelistaId, panelId: panelId, status: EstadoPanel.accepted.rawValue)
    }
    
    func rejectInvitation(_ action: UIAlertAction) {
        guard let panelistaId = User.currentUser?.id, let panelId = self.selectedPanel?.id else {
            return
        }
        
        self.acceptRejectCall(panelistaId, panelId: panelId, status: EstadoPanel.rejected.rawValue)
    }
    
    func acceptRejectCall(_ panelistaId: Int, panelId: Int, status: Int) {
        let parameters: [String : Any] = [
            "panelista" : panelistaId,
            "panel" : panelId,
            "estado" : status
        ]
        
        self.selectedAction = status
        self.loadingAlert = self.presentAlertWithTitle("Cargando", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
        Controller.request(for: .invitationReponse, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(_ response: NSDictionary) {
        self.loadingAlert?.dismiss(animated: false, completion: {
            if (response["status"] as? String == "SUCCESS") {
                if (self.selectedAction == 1) {
                    self.selectedPanel?.estado = .accepted
                } else {
                    self.selectedPanel?.estado = .rejected
                    self.paneles?.remove(at: self.selectedIndex)
                }
                
                self.selectedAction = 0
                self.selectedIndex = 0
                self.selectedPanel = nil
                
                self.tableView.reloadData()
            } else {
                self.presentAlertWithTitle("Error", withMessage: "Hubo un error al procesar su respuesta. Por favor, inténtelo más tarde.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
            }
        })
    }
    
    func errorHandler(_ response: NSDictionary) {
        self.loadingAlert?.dismiss(animated: false, completion: {
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
    
}
