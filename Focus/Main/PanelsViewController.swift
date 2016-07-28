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
        
        self.navigationItem.title = "Paneles"
        
        let parameters: [String : AnyObject] = [
            "panelista" : "\(User.currentUser!.id)"
        ]
        
        Controller.requestForAction(.GET_DATA, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        var paneles: [Panel] = [Panel]()
        
        if let panels = response["paneles"] as? [AnyObject] {
            for object in panels {
                let panel = object as! NSDictionary
                let newPanel = Panel(id: panel["id"] as! Int, nombre: panel["nombre"] as! String, fechaInicio: panel["fechaInicio"] as! String, fechaFin: panel["fechaFin"] as! String)
                
                for object2 in panel["encuestas"] as! [AnyObject] {
                    let survey = object2 as! NSDictionary
                    let newSurvey = Encuesta(id: survey["id"] as! Int, nombre: survey["nombre"] as! String, fechaInicio: survey["fechaInicio"] as! String, fechaFin: survey["fechaFin"] as! String, contestada: survey["contestada"] as! Bool)
                    
                    newPanel.encuestas?.append(newSurvey)
                }
                
                paneles.append(newPanel)
            }
            
            self.appDelegate().paneles = paneles
            self.tableView.reloadData()
        }
    }
    
    func errorHandler(response: NSDictionary) {
        print(response["error"])
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
 
}
