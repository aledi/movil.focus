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
    
    // MARK: - Table view data source

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
            
            cell.accessoryType = encuesta.contestada ? .Checkmark : .DisclosureIndicator
        }
        
        return cell
    }
    
}
