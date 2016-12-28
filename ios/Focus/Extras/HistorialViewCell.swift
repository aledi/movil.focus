//
//  HistorialViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 28/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class HistorialViewCell: UITableViewCell {
    
    @IBOutlet var encuestaLabel: UILabel!
    @IBOutlet var panelLabel: UILabel!
    
    @IBOutlet var fechaRespuestaLabel: UILabel!
    @IBOutlet var fechaInicioLabel: UILabel!
    @IBOutlet var fechaFinLabel: UILabel!
    
    func configureforHistorial(historial: Historial) {
        self.encuestaLabel.text = historial.nombreEncuesta
        self.panelLabel.text = historial.nombrePanel
        
        self.fechaRespuestaLabel.text = "---"
        self.fechaInicioLabel.text = "---"
        self.fechaFinLabel.text = "---"
        
        self.accessoryType = .None
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if (historial.fechaIniEncuesta != nil) {
            self.fechaInicioLabel.text = dateFormatter.stringFromDate(historial.fechaIniEncuesta!)
        }
        
        if (historial.fechaFinEncuesta != nil) {
            self.fechaFinLabel.text = dateFormatter.stringFromDate(historial.fechaFinEncuesta!)
        }
        
        if (historial.fechaRespuesta != nil) {
            dateFormatter.dateFormat = "MMMM d, YYYY hh:mm"
            
            self.fechaRespuestaLabel.text = dateFormatter.stringFromDate(historial.fechaRespuesta!)
            self.accessoryType = .Checkmark
        }
    }
    
}
