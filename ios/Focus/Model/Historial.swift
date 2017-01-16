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
    var fechaIniPanel: NSDate?
    var fechaFinPanel: NSDate?
    var nombreEncuesta = ""
    var fechaIniEncuesta: NSDate?
    var fechaFinEncuesta: NSDate?
    var fechaRespuesta: NSDate?
    
    init(nombrePanel: String, fechaIniPanel: String?, fechaFinPanel: String?, nombreEncuesta: String, fechaIniEncuesta: String?, fechaFinEncuesta: String?, fechaRespuesta: String?, horaRespuesta: String?) {
        self.nombrePanel = nombrePanel
        self.nombreEncuesta = nombreEncuesta
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        if (fechaIniPanel != nil) {
            self.fechaIniPanel = dateFormatter.dateFromString(fechaIniPanel!)
        }
        
        if (fechaFinPanel != nil) {
            self.fechaFinPanel = dateFormatter.dateFromString(fechaFinPanel!)
        }
        
        if (fechaIniEncuesta != nil) {
            self.fechaIniEncuesta = dateFormatter.dateFromString(fechaIniEncuesta!)
        }
        
        if (fechaFinEncuesta != nil) {
            self.fechaFinEncuesta = dateFormatter.dateFromString(fechaFinEncuesta!)
        }
        
        if (fechaRespuesta != nil) {
            dateFormatter.dateFormat = "hh:mm:ss YYYY-MM-dd"
            self.fechaRespuesta = dateFormatter.dateFromString("\(horaRespuesta!) \(fechaRespuesta!)")
        }
    }
    
}
