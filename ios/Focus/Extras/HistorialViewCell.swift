//
//  HistorialViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 28/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class HistorialViewCell: TableViewCell {
    
    @IBOutlet var encuestaLabel: UILabel!
    @IBOutlet var fechaRespuestaLabel: UILabel!
    
    func configure(for historial: Historial) {
        self.encuestaLabel.text = historial.nombreEncuesta
        self.fechaRespuestaLabel.text = "---"
        
        self.accessoryType = .none
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        if (historial.fechaRespuesta != nil) {
            dateFormatter.dateFormat = "MMMM d, YYYY hh:mm"
            
            self.fechaRespuestaLabel.text = dateFormatter.string(from: historial.fechaRespuesta! as Date)
            self.accessoryType = .checkmark
        }
    }
    
}
