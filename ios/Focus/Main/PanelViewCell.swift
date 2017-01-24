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
    
    func configure(for panel: Panel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        self.nombreLabel.text = panel.nombre
        self.fechaIniLabel.text = dateFormatter.string(from: panel.fechaInicio as Date).capitalized
        self.fechaFinLabel.text = dateFormatter.string(from: panel.fechaFin as Date).capitalized
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .default
        
        if (panel.estado != .accepted) {
            self.accessoryType = .detailButton
            self.selectionStyle = .none
        } else if (panel.encuestas?.count == 0) {
            self.accessoryType = .none
            self.selectionStyle = .none
        }
    }
    
}
