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
    var fechaInicio: Date
    var fechaFin: Date
    var contestada: Bool
    var preguntas: [Pregunta]?
    
    init(id: Int, nombre: String, fechaInicio: String, fechaFin: String, contestada: Bool) {
        self.id = id
        self.nombre = nombre
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        self.fechaInicio = dateFormatter.date(from: fechaInicio)!
        self.fechaFin = dateFormatter.date(from: fechaFin)!
        
        self.contestada = contestada
    }
    
}
