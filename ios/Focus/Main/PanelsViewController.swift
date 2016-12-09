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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
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
        return (self.paneles == nil || self.paneles!.count == 0) ? 1 : self.paneles!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.paneles == nil || self.paneles!.count == 0) ? 270 : super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.paneles == nil || self.paneles!.count == 0) {
            return tableView.dequeueReusableCellWithIdentifier("noContentCell", forIndexPath: indexPath)
        }
        
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
        
        self.presentAlertWithTitle("No hay Encuestas", withMessage: "Este panel aún no cuenta con encuestas. Por favor, espere a que una encuesta sea habilitada.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
    }
    
}
