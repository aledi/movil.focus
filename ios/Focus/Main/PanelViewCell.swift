//
//  PanelViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 31/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PanelViewCell: UITableViewCell {
    
    @IBOutlet var nombreLabel: UILabel!
    @IBOutlet var fechaIniLabel: UILabel!
    @IBOutlet var fechaFinLabel: UILabel!
    
    func configureFor(panel: Panel) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        self.nombreLabel.text = panel.nombre
        self.fechaIniLabel.text = dateFormatter.stringFromDate(panel.fechaInicio).capitalizedString
        self.fechaFinLabel.text = dateFormatter.stringFromDate(panel.fechaFin).capitalizedString
        
        self.accessoryType = .DisclosureIndicator
        self.selectionStyle = .Default
        
        if (panel.estado != .Accepted) {
            self.accessoryType = .DetailButton
            self.selectionStyle = .None
        } else if (panel.encuestas?.count == 0) {
            self.accessoryType = .None
            self.selectionStyle = .None
        }
    }
    
}
