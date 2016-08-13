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
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paneles = self.appDelegate.paneles
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
        return self.paneles?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("panelCell", forIndexPath: indexPath)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if let panel = self.paneles?[indexPath.row] {
            (cell.viewWithTag(10) as! UILabel).text = panel.nombre
            (cell.viewWithTag(20) as! UILabel).text = dateFormatter.stringFromDate(panel.fechaInicio).capitalizedString
            (cell.viewWithTag(30) as! UILabel).text = dateFormatter.stringFromDate(panel.fechaFin).capitalizedString
            
            if (panel.encuestas?.count == 0) {
                cell.accessoryType = .None
                cell.selectionStyle = .None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let panel = self.paneles![indexPath.row]
        
        if (panel.encuestas?.count > 0) {
            self.performSegueWithIdentifier("showEncuestas", sender: panel)
            return
        }
        
        let alertController = UIAlertController(
            title: "No hay Encuestas",
            message: "Este panel aún no cuenta con encuestas. Por favor, espere a que una encuesta sea habilitada.",
            preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
