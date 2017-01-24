//
//  PreguntasViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 01/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

let PREGUNTA_CELL = "PreguntaViewCell"
let PREGUNTA_COMBO_CELL = "PreguntaComboViewCell"
let PREGUNTA_ESCALA_CELL = "PreguntaEscalaViewCell"
let PREGUNTA_MATRIZ_CELL = "PreguntaMatrizViewCell"

class PreguntasViewController: UITableViewController {
    
    var responseId: Int?
    var encuestaId: Int?
    var preguntas: [Pregunta]?
    var respuesta: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: PREGUNTA_CELL, bundle: nil), forCellReuseIdentifier: PREGUNTA_CELL)
        self.tableView.register(UINib(nibName: PREGUNTA_COMBO_CELL, bundle: nil), forCellReuseIdentifier: PREGUNTA_COMBO_CELL)
        self.tableView.register(UINib(nibName: PREGUNTA_ESCALA_CELL, bundle: nil), forCellReuseIdentifier: PREGUNTA_ESCALA_CELL)
        self.tableView.register(UINib(nibName: PREGUNTA_MATRIZ_CELL, bundle: nil), forCellReuseIdentifier: PREGUNTA_MATRIZ_CELL)
        
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Video
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func dismissVideoPlayer(_ segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
    }
    
    func presentVideo(_ sender: UIButton) {
        let navigationController = UIStoryboard(name: "Preguntas", bundle: nil).instantiateViewController(withIdentifier: "Video") as! UINavigationController
        let moviePlayerController = navigationController.topViewController as! MoviePlayerViewController
        
        let pregunta = self.preguntas![sender.tag]
        
        moviePlayerController.videoName = pregunta.video
        pregunta.didSeeVideo = true
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pregunta \(section + 1)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.preguntas?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pregunta = self.preguntas![indexPath.section]
        
        if (pregunta.tipo == TipoPregunta.unica.rawValue && pregunta.asCombo) {
            let cell = tableView.dequeueReusableCell(withIdentifier: PREGUNTA_COMBO_CELL, for: indexPath) as! PreguntaComboViewCell
            
            cell.pregunta = pregunta
            cell.videoHandler = #selector(self.presentVideo)
            cell.configureForPregunta(indexPath.section)
            
            return cell
        } else if (pregunta.tipo == TipoPregunta.matriz.rawValue) {
            let cell = tableView.dequeueReusableCell(withIdentifier: PREGUNTA_MATRIZ_CELL, for: indexPath) as! PreguntaMatrizViewCell
            
            cell.pregunta = pregunta
            cell.videoHandler = #selector(self.presentVideo)
            cell.configureForPregunta(indexPath.section)
            
            return cell
        } else if (pregunta.tipo == TipoPregunta.escala.rawValue) {
            let cell = tableView.dequeueReusableCell(withIdentifier: PREGUNTA_ESCALA_CELL, for: indexPath) as! PreguntaEscalaViewCell
            
            cell.pregunta = pregunta
            cell.videoHandler = #selector(self.presentVideo)
            cell.configureForPregunta(indexPath.section)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PREGUNTA_CELL, for: indexPath) as! PreguntaViewCell
        
        cell.pregunta = pregunta
        cell.videoHandler = #selector(self.presentVideo)
        cell.configure(for: indexPath.section)
        
        return cell
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Save Answers
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func doneAnswering(_ sender: AnyObject) {
        self.dismissKeyboard()
        self.respuesta = ""
        
        for pregunta in self.preguntas! {
            if (pregunta.tipo == TipoPregunta.multiple.rawValue) {
                pregunta.respuesta = ""
                
                for i in 0..<pregunta.opciones.count {
                    pregunta.respuesta += pregunta.selectedOptions[i] ? "\(pregunta.opciones[i])&" : ""
                }
            } else if (pregunta.tipo == TipoPregunta.matriz.rawValue) {
                if (!pregunta.matrizAnswered) {
                    return self.missingAnswerAlert(pregunta.numPregunta)
                }
                
                pregunta.respuesta = ""
                
                for i in 0..<pregunta.subPreguntas.count {
                    let selectedOption = pregunta.selectedSubPreguntas[i]
                    pregunta.respuesta += "\(pregunta.opciones[selectedOption])&"
                }
            }
            
            if (!pregunta.didSeeVideo) {
               return self.missingVideo(pregunta.numPregunta)
            }
            
            if (pregunta.respuesta.isEmpty) {
                return self.missingAnswerAlert(pregunta.numPregunta)
            }
            
            if (pregunta.tipo == TipoPregunta.ordenamiento.rawValue && pregunta.nextOption <= pregunta.opciones.count) {
                return self.missingOrder(pregunta.numPregunta)
            }
            
            self.respuesta += "\(pregunta.respuesta)|"
        }
        
        self.saveAnswers()
    }
    
    func missingAnswerAlert(_ numPregunta: Int) {
        let alertTitle = "La pregunta \(numPregunta) no ha sido respondida."
        let alertMesssage = "Por favor, responda a todas las preguntas e intente enviar las respuestas nuevamente."
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
    }
    
    func missingVideo(_ numPregunta: Int) {
        let alertTitle = "El video de la pregunta \(numPregunta) no ha sido visto."
        let alertMesssage = "Por favor, vea el video antes de responder a la pregunta."
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
    }
    
    func missingOrder(_ numPregunta: Int) {
        let alertTitle = "La pregunta \(numPregunta) no ha sido ordenada."
        let alertMesssage = "Por favor, ordene todas las opciones disponibles."
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [nil])
    }
    
    func saveAnswers() {
        let parameters: [String : Any] = [
            "id" : self.responseId!,
            "respuestas" : self.respuesta,
            "panelista" : User.currentUser!.id,
            "encuesta" : self.encuestaId!
        ]
        
        Controller.request(for: .saveAnswers, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(_ response: NSDictionary) {
        if (response["status"] as? String != "SUCCESS") {
            return self.errorHandler(response)
        }
        
        let alertTitle = "Respuestas Guardadas"
        let alertMesssage = "Gracias por responder la encuesta."
        
        func firstBlock(_ action: UIAlertAction) {
            self.performSegue(withIdentifier: "doneAnswering", sender: nil)
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["OK"], withButtonStyles: [.cancel], andButtonHandlers: [firstBlock])
    }
    
    func errorHandler(_ response: NSDictionary) {
        let alertTitle = "Error"
        let alertMesssage = "No pudimos guardar tus respuestas en este momento. Intente de nuevo o póngase en contacto."
        
        func firstBlock(_ action: UIAlertAction) {
            self.saveAnswers()
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["Reintentar", "OK"], withButtonStyles: [.default, .cancel], andButtonHandlers: [firstBlock, nil])
        
        print(response["error"] ?? "")
    }
    
}
