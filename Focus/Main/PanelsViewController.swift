//
//  PanelsViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PanelsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters: [String : AnyObject] = [
            "panelista" : "\(User.currentUser!.id)"
        ]
        
        Controller.requestForAction(.GET_DATA, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "showEncuestas") {
            (segue.destinationViewController as! EncuestasViewController).encuestas = (sender as! Panel).encuestas
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate().paneles?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("panelCell", forIndexPath: indexPath)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if let panel = self.appDelegate().paneles?[indexPath.row] {
            (cell.viewWithTag(10) as! UILabel).text = panel.nombre
            (cell.viewWithTag(20) as! UILabel).text = dateFormatter.stringFromDate(panel.fechaInicio)
            (cell.viewWithTag(30) as! UILabel).text = dateFormatter.stringFromDate(panel.fechaFin)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let panel = self.appDelegate().paneles![indexPath.row]
        self.performSegueWithIdentifier("showEncuestas", sender: panel)
    }
    
    // MARK: - Actions
    
    @IBAction func logOut(sender: AnyObject) {
        NSUserDefaults.removeUserDefaults()
        
        self.performSegueWithIdentifier("logOut", sender: nil)
    }
    
    // MARK: - Fetch
    
    func successHandler(response: NSDictionary) {
        var paneles: [Panel] = [Panel]()
        
        if let panels = response["paneles"] as? [AnyObject] {
            for object in panels {
                let panel = object as! NSDictionary
                let newPanel = Panel(id: panel["id"] as! Int, nombre: panel["nombre"] as! String, fechaInicio: panel["fechaInicio"] as! String, fechaFin: panel["fechaFin"] as! String)
                
                var encuestas: [Encuesta] = [Encuesta]()
                
                for object2 in panel["encuestas"] as! [AnyObject] {
                    let survey = object2 as! NSDictionary
                    let newSurvey = Encuesta(id: survey["id"] as! Int, nombre: survey["nombre"] as! String, fechaInicio: survey["fechaInicio"] as! String, fechaFin: survey["fechaFin"] as! String, contestada: survey["contestada"] as! Bool)
                    
                    var preguntas: [Pregunta] = [Pregunta]()
                    
                    for object3 in survey["preguntas"] as! [AnyObject] {
                        let question = object3 as! NSDictionary
                        let newQuestion = Pregunta(id: question["id"] as! Int, tipo: question["tipo"] as! Int, numPregunta: question["numPregunta"] as! Int, pregunta: question["pregunta"] as! String, video: question["video"] as! String, imagen: question["video"] as! String, op1: question["op1"] as! String, op2: question["op2"] as! String, op3: question["op3"] as! String, op4: question["op4"] as! String, op5: question["op5"] as! String, op6: question["op6"] as! String, op7: question["op7"] as! String, op8: question["op8"] as! String, op9: question["op9"] as! String, op10: question["op10"] as! String)
                        
                        preguntas.append(newQuestion)
                    }
                    
                    newSurvey.preguntas = preguntas
                    encuestas.append(newSurvey)
                }
                
                newPanel.encuestas = encuestas
                paneles.append(newPanel)
            }
            
            self.appDelegate().paneles = paneles
            self.tableView.reloadData()
        }
    }
    
    func errorHandler(response: NSDictionary) {
        print(response["error"])
    }
    
}
