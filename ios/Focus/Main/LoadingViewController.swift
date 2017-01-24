//
//  LoadingViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 07/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContent()
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
    
    func loadContent() {
        let parameters: [String : Any] = [
            "panelista" : "\(User.currentUser!.id)"
        ]
        
        self.spinner.startAnimating()
        Controller.request(for: .getData, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Fetch
    // -----------------------------------------------------------------------------------------------------------
    
    func successHandler(_ response: NSDictionary) {
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
            self.spinner.stopAnimating()
            self.performSegue(withIdentifier: "showContent", sender: nil)
        }
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
            self.loadContent()
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMessage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.default, .cancel], andButtonHandlers: [firstBlock, nil])
        print(response["error"] ?? "")
    }

}
