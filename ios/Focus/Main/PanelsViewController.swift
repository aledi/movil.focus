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
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        self.paneles = self.appDelegate.paneles?.filter({ (panel) -> Bool in
            panel.estado != .Rejected
        })
        self.tableView.reloadData()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Navigation
    // -----------------------------------------------------------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "showEncuestas") {
            (segue.destinationViewController as! EncuestasViewController).encuestas = (sender as! Panel).encuestas
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.paneles == nil || self.paneles!.count == 0) ? 1 : self.paneles!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.paneles == nil || self.paneles!.count == 0) ? 270 : super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.paneles == nil || self.paneles!.count == 0) {
            return tableView.dequeueReusableCellWithIdentifier("noContentCell", forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("panelCell", forIndexPath: indexPath) as! PanelViewCell
        cell.configureFor(self.paneles![indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let panel = self.paneles![indexPath.row]
        
        self.selectedPanel = panel
        self.selectedIndex = indexPath.row
        
        if (panel.estado != .Accepted) {
            self.presentAlertWithTitle("Invitación", withMessage: "\(panel.descripcion)\n\nAcepte la invitación para comenzar a participar.", withButtonTitles: ["Aceptar", "Rechazar", "Cancelar"], withButtonStyles: [.Default, .Destructive, .Cancel], andButtonHandlers: [self.acceptInvitation, self.rejectInvitation, nil])
        } else if (panel.encuestas?.count == 0) {
            self.presentAlertWithTitle("No hay Encuestas", withMessage: "Este panel aún no cuenta con encuestas. Por favor, espere a que una encuesta sea habilitada.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
        } else {
            self.performSegueWithIdentifier("showEncuestas", sender: panel)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Accept/Reject
    // -----------------------------------------------------------------------------------------------------------
    
    func acceptInvitation(action: UIAlertAction) {
        guard let panelistaId = User.currentUser?.id, let panelId = self.selectedPanel?.id else {
            return
        }
        
        self.selectedAction = 1
        self.acceptRejectCall(panelistaId, panelId: panelId, status: EstadoPanel.Accepted.rawValue)
    }
    
    func rejectInvitation(action: UIAlertAction) {
        guard let panelistaId = User.currentUser?.id, let panelId = self.selectedPanel?.id else {
            return
        }
        
        self.selectedAction = 2
        self.acceptRejectCall(panelistaId, panelId: panelId, status: EstadoPanel.Rejected.rawValue)
    }
    
    func acceptRejectCall(panelistaId: Int, panelId: Int, status: Int) {
        let parameters: [String : AnyObject] = [
            "panelista" : panelistaId,
            "panel" : panelId,
            "estado" : status
        ]
        
        self.loadingAlert = self.presentAlertWithTitle("Cargando", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
        Controller.requestForAction(.INVITATION_RESPONE, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        self.loadingAlert?.dismissViewControllerAnimated(false, completion: {
            if (response["status"] as? String == "SUCCESS") {
                if (self.selectedAction == 1) {
                    self.selectedPanel?.estado = .Accepted
                } else {
                    self.selectedPanel?.estado = .Rejected
                    self.paneles?.removeAtIndex(self.selectedIndex)
                }
                
                self.selectedAction = 0
                self.selectedIndex = 0
                self.selectedPanel = nil
                
                self.tableView.reloadData()
            } else {
                self.presentAlertWithTitle("Error", withMessage: "Hubo un error al procesar su respuesta. Por favor, inténtelo más tarde.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
            }
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
            
            self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
            print(response["error"])
        })
    }
    
}
