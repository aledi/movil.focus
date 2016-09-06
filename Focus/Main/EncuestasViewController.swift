//
//  EncuestasViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 27/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class EncuestasViewController: UITableViewController {

    var encuestas: [Encuesta]?
    var selectedEncuesta: Encuesta?
    var loadingAlert: UIAlertController?
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Navigation
    // -----------------------------------------------------------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "answerEncuesta") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let preguntasViewController = navigationController.topViewController as! PreguntasViewController
            
            preguntasViewController.preguntas = self.selectedEncuesta!.preguntas
            preguntasViewController.id = sender as? Int
        }
    }
    
    @IBAction func doneAnsweringEncuesta(segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
        self.tableView.reloadData()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.encuestas?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("encuestaCell", forIndexPath: indexPath)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if let encuesta = self.encuestas?[indexPath.row] {
            (cell.viewWithTag(10) as! UILabel).text = encuesta.nombre
            (cell.viewWithTag(15) as! UILabel).text = "\(encuesta.preguntas?.count ?? 0) pregunta(s)"
            (cell.viewWithTag(20) as! UILabel).text = dateFormatter.stringFromDate(encuesta.fechaInicio).capitalizedString
            (cell.viewWithTag(30) as! UILabel).text = dateFormatter.stringFromDate(encuesta.fechaFin).capitalizedString
            
            if (encuesta.contestada) {
                cell.accessoryType = .Checkmark
                cell.selectionStyle = .None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedEncuesta = self.encuestas![indexPath.row]
        
        if (!self.selectedEncuesta!.contestada) {
            func firstBlock(action: UIAlertAction) {
                let parameters: [String : AnyObject] = [
                    "encuesta" : self.selectedEncuesta!.id,
                    "panelista" : User.currentUser!.id
                ]
                
                
                self.loadingAlert = self.presentAlertWithTitle("Cargando", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
                Controller.requestForAction(.START_SURVEY, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
            }
            
            self.presentAlertWithTitle("Atención", withMessage: "Una vez iniciada la encuesta, deberá contestarla completamente. No se podrá salir y regresar de la encuesta, ni contestarla nuevamente.", withButtonTitles: ["Responder", "Cancelar"], withButtonStyles: [.Default, .Cancel], andButtonHandlers: [firstBlock, nil])
            
            return
        }
        
        self.presentAlertWithTitle("Encuesta Contestada", withMessage: "Esta encuesta ya ha sido contestada. Solo puede responder una vez a la encuesta.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
    }
    
    func successHandler(response: NSDictionary) {
        self.loadingAlert?.dismissViewControllerAnimated(true, completion: { 
            if (response["status"] as? String == "SUCCESS") {
                let id = response["id"] as! Int
                self.selectedEncuesta!.contestada = true
                self.performSegueWithIdentifier("answerEncuesta", sender: id)
            } else {
                self.presentAlertWithTitle("Error", withMessage: "No hemos podido iniciar tu sesión. Por favor, intenta más tarde.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
            }
        })
    }
    
    func errorHandler(response: NSDictionary) {
        var alertTitle = ""
        var alertMessage = ""
        
        switch (response["error"] as! NSError).code {
        case -1009:
            alertTitle = "Sin conexión a internet"
            alertMessage = "Para contestar la encuesta, su dispositivo debe estar conectado a internet."
        case -1003:
            alertTitle = "Servidor no disponible"
            alertMessage = "Nuestro servidor no está disponible por el momento."
        default:
            break
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
        print(response["error"])
    }
    
}
