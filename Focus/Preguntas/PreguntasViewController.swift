//
//  PreguntasViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 01/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

let PREGUNTA_CELL = "PreguntaViewCell"

class PreguntasViewController: UITableViewController {
    
    var idEncuesta: Int?
    var preguntas: [Pregunta]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: PREGUNTA_CELL, bundle: nil), forCellReuseIdentifier: PREGUNTA_CELL)
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pregunta \(section + 1)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.preguntas?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PREGUNTA_CELL, forIndexPath: indexPath) as! PreguntaViewCell
        cell.pregunta = self.preguntas![indexPath.section]
        cell.configureForPregunta()
        cell.selectionStyle = .None
        
        return cell
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Save Answers
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func doneAnswering(sender: AnyObject) {
        var respuesta = ""
        
        for pregunta in self.preguntas! {
            if (pregunta.tipo == TipoPregunta.Multiple.rawValue) {
                for i in 0..<pregunta.opciones.count {
                    pregunta.respuesta += pregunta.selectedOptions[i] ? "\(pregunta.opciones[i])&" : ""
                }
            }
            
            respuesta += "\(pregunta.respuesta)|"
        }
        
        let parameters: [String : AnyObject] = [
            "encuesta" : self.idEncuesta!,
            "panelista" : User.currentUser!.id,
            "respuestas" : respuesta
        ]
        
        Controller.requestForAction(.SAVE_ANSWERS, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        if (response["status"] as? String == "SUCCESS") {
            let alertController = UIAlertController(
                title: "Respuestas Guardadas",
                message: "Gracias por responder la encuesta.",
                preferredStyle: .Alert
            )
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                self.performSegueWithIdentifier("doneAnswering", sender: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title: "Error",
                message: "No pudimos guardar tus respuestas en este momento. Por favor, inténtalo más tarde.",
                preferredStyle: .Alert
            )
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                self.performSegueWithIdentifier("doneAnswering", sender: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func errorHandler(response: NSDictionary) {
        print(response["error"])
    }
}
