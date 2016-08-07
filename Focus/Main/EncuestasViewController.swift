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
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Navigation
    // -----------------------------------------------------------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "answerEncuesta") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let preguntasViewController = navigationController.topViewController as! PreguntasViewController
            
            preguntasViewController.preguntas = (sender as! Encuesta).preguntas
            preguntasViewController.idEncuesta = (sender as! Encuesta).id
        }
    }
    
    @IBAction func doneAnsweringEncuesta(segue: UIStoryboardSegue) {
        segue.destinationViewController.dismissViewControllerAnimated(true, completion: nil)
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
            (cell.viewWithTag(20) as! UILabel).text = dateFormatter.stringFromDate(encuesta.fechaInicio)
            (cell.viewWithTag(30) as! UILabel).text = dateFormatter.stringFromDate(encuesta.fechaFin)
            
            if (encuesta.contestada) {
                cell.accessoryType = .Checkmark
                cell.selectionStyle = .None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let encuesta = self.encuestas![indexPath.row]
        
        if (!encuesta.contestada) {
            let alertController = UIAlertController(
                title: "Atención",
                message: "Una vez iniciada la encuesta, deberá contestarla completamente. No se podrá salir y regresar de la encuesta, ni contestarla nuevamente.",
                preferredStyle: .Alert
            )
            
            alertController.addAction(UIAlertAction(title: "Responder", style: .Default, handler: { (action) in
                let encuesta = self.encuestas![indexPath.row]
                encuesta.contestada = true
                
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                self.performSegueWithIdentifier("answerEncuesta", sender: encuesta)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let alertController = UIAlertController(
            title: "Encuesta Contestada",
            message: "Esta encuesta ya ha sido contestada. Solo puede responder una vez a la encuesta.",
            preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
