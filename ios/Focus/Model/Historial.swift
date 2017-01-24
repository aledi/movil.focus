//
//  Historial.swift
//  Focus
//
//  Created by Eduardo Cristerna on 28/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation

class Historial {
    
    var nombrePanel = ""
    var fechaIniPanel: Date?
    var fechaFinPanel: Date?
    var nombreEncuesta = ""
    var fechaIniEncuesta: Date?
    var fechaFinEncuesta: Date?
    var fechaRespuesta: Date?
    
    init(nombrePanel: String, fechaIniPanel: String?, fechaFinPanel: String?, nombreEncuesta: String, fechaIniEncuesta: String?, fechaFinEncuesta: String?, fechaRespuesta: String?, horaRespuesta: String?) {
        self.nombrePanel = nombrePanel
        self.nombreEncuesta = nombreEncuesta
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        if (fechaIniPanel != nil) {
            self.fechaIniPanel = dateFormatter.date(from: fechaIniPanel!)
        }
        
        if (fechaFinPanel != nil) {
            self.fechaFinPanel = dateFormatter.date(from: fechaFinPanel!)
        }
        
        if (fechaIniEncuesta != nil) {
            self.fechaIniEncuesta = dateFormatter.date(from: fechaIniEncuesta!)
        }
        
        if (fechaFinEncuesta != nil) {
            self.fechaFinEncuesta = dateFormatter.date(from: fechaFinEncuesta!)
        }
        
        if (fechaRespuesta != nil) {
            dateFormatter.dateFormat = "hh:mm:ss YYYY-MM-dd"
            self.fechaRespuesta = dateFormatter.date(from: "\(horaRespuesta!) \(fechaRespuesta!)")
        }
    }
    
}
