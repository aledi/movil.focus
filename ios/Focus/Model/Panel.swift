//
//  Panel.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation
import UIKit

enum EstadoPanel: Int {
    case Pendiente = 0
    case Aceptado = 1
    case Rechazado = 2
}

class Panel {
    
    var id: Int
    var nombre: String
    var descripcion: String
    var fechaInicio: NSDate
    var fechaFin: NSDate
    var encuestas: [Encuesta]?
    var estado: EstadoPanel
    
    var encuestasPendientes: Int {
        guard let encuestas = self.encuestas else {
            return 0
        }
        
        var pending = 0
        
        for encuesta in encuestas {
            pending += encuesta.contestada ? 0 : 1
        }
        
        return pending
    }
    
    init(id: Int, nombre: String, descripcion: String, fechaInicio: String, fechaFin: String, estado: Int) {
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        self.fechaInicio = dateFormatter.dateFromString(fechaInicio)!
        self.fechaFin = dateFormatter.dateFromString(fechaFin)!
        
        self.estado = EstadoPanel(rawValue: estado)!
    }
    
    static func savePaneles(paneles: [Panel]?) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.paneles = paneles
    }
    
}
