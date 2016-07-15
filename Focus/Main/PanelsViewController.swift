//
//  PanelsViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PanelsViewController: UITableViewController {
    
    var paneles: [Panel] = [Panel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Paneles"
        
        Controller.requestForAction(.GET_PANELES, withParameters: [String : AnyObject](), withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        if let panels = response["results"] as? [AnyObject] {
            for object in panels {
                let panel = object as! NSDictionary
                let newPanel = Panel(id: panel["id"] as! Int, nombre: panel["nombre"] as! String)
                self.paneles.append(newPanel)
            }
            
            self.appDelegate().user?.paneles = self.paneles
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
        return self.paneles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("panelCell", forIndexPath: indexPath)
        
        (cell.viewWithTag(10) as! UILabel).text = self.paneles[indexPath.row].nombre
        (cell.viewWithTag(20) as! UILabel).text = "\(self.paneles[indexPath.row].id)"
        
        return cell
    }
 
}
