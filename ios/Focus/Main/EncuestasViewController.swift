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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "answerEncuesta") {
            let navigationController = segue.destination as! UINavigationController
            let preguntasViewController = navigationController.topViewController as! PreguntasViewController
            
            preguntasViewController.preguntas = self.selectedEncuesta!.preguntas
            preguntasViewController.responseId = sender as? Int
            preguntasViewController.encuestaId = self.selectedEncuesta?.id
        }
    }
    
    @IBAction func doneAnsweringEncuesta(_ segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
        self.tableView.reloadData()
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.encuestas?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "encuestaCell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if let encuesta = self.encuestas?[indexPath.row] {
            (cell.viewWithTag(10) as! UILabel).text = encuesta.nombre
            (cell.viewWithTag(15) as! UILabel).text = "\(encuesta.preguntas?.count ?? 0) pregunta(s)"
            (cell.viewWithTag(20) as! UILabel).text = dateFormatter.string(from: encuesta.fechaInicio).capitalized
            (cell.viewWithTag(30) as! UILabel).text = dateFormatter.string(from: encuesta.fechaFin).capitalized
            
            if (encuesta.contestada) {
                cell.accessoryType = .checkmark
                cell.selectionStyle = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedEncuesta = self.encuestas![indexPath.row]
        
        if (!self.selectedEncuesta!.contestada) {
            func firstBlock(_ action: UIAlertAction) {
                let parameters: [String : Any] = [
                    "encuesta" : self.selectedEncuesta!.id,
                    "panelista" : User.currentUser!.id
                ]
                
                self.loadingAlert = self.presentAlertWithTitle("Cargando", withMessage: nil, withButtonTitles: [], withButtonStyles: [], andButtonHandlers: [])
                Controller.request(for: .startSurvey, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
            }
            
            self.presentAlertWithTitle("Atención", withMessage: "Una vez iniciada la encuesta, deberá contestarla completamente. No se podrá salir y regresar de la encuesta, ni contestarla nuevamente.", withButtonTitles: ["Responder", "Cancelar"], withButtonStyles: [.default, .cancel], andButtonHandlers: [firstBlock, nil])
            
            return
        }
        
        self.presentAlertWithTitle("Encuesta Contestada", withMessage: "Esta encuesta ya ha sido contestada. Solo puede responder una vez a la encuesta.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
    }
    
    func successHandler(_ response: NSDictionary) {
        self.loadingAlert?.dismiss(animated: true, completion: { 
            if (response["status"] as? String == "SUCCESS") {
                let id = response["id"] as! Int
                self.selectedEncuesta!.contestada = true
                self.performSegue(withIdentifier: "answerEncuesta", sender: id)
            } else {
                self.presentAlertWithTitle("Error", withMessage: "No hemos podido iniciar tu sesión. Por favor, intenta más tarde.", withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
            }
        })
    }
    
    func errorHandler(_ response: NSDictionary) {
        self.loadingAlert?.dismiss(animated: true, completion: { 
            var alertTitle = ""
            var alertMessage = ""
            
            switch (response["error"] as! NSError).code {
            case -1009:
                alertTitle = "Sin conexión a internet"
                alertMessage = "Para contestar la encuesta, su dispositivo debe estar conectado a internet."
            default:
                alertTitle = "Servidor no disponible"
                alertMessage = "Nuestro servidor no está disponible por el momento."
            }
            
            self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
            print(response["error"] ?? "")
        })
    }
    
}
