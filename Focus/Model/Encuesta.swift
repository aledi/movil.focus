//
//  Encuesta.swift
//  Focus
//
//  Created by Eduardo Cristerna on 27/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation

class Encuesta {
    
    var id: Int
    var nombre: String
    var fechaInicio: NSDate
    var fechaFin: NSDate
    var contestada: Bool
    var preguntas: [Pregunta]?
    
    init(id: Int, nombre: String, fechaInicio: String, fechaFin: String, contestada: Bool) {
        self.id = id
        self.nombre = nombre
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        self.fechaInicio = dateFormatter.dateFromString(fechaInicio)!
        self.fechaFin = dateFormatter.dateFromString(fechaInicio)!
        
        self.contestada = contestada
    }
    
}
