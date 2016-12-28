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
    @IBOutlet var fechaInicioLabel: UILabel!
    @IBOutlet var fechaFinLabel: UILabel!
    @IBOutlet var panelLabel: UILabel!
    @IBOutlet var fechaRespuestaLabel: UILabel!
    
    func configureforHistorial(historial: Historial) {
        self.encuestaLabel.text = historial.nombreEncuesta
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if (historial.fechaIniEncuesta != nil) {
            self.fechaInicioLabel.text = dateFormatter.stringFromDate(historial.fechaIniEncuesta!)
        }
        
        if (historial.fechaFinEncuesta != nil) {
            self.fechaFinLabel.text = dateFormatter.stringFromDate(historial.fechaFinEncuesta!)
        }
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY hh:mm"
        
        if (historial.fechaRespuesta != nil) {
            self.fechaRespuestaLabel.text = dateFormatter.stringFromDate(historial.fechaRespuesta!)
            self.accessoryType = .Checkmark
        } else {
            self.fechaRespuestaLabel.text = "---"
            self.accessoryType = .None
        }
    }
    
}
