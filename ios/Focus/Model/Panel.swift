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
    case pending = 0
    case accepted = 1
    case rejected = 2
}

class Panel {
    
    var id: Int
    var nombre: String
    var descripcion: String
    var fechaInicio: Date
    var fechaFin: Date
    var encuestas: [Encuesta]?
    var estado: EstadoPanel
    
    var encuestasPendientes: Int {
        guard let encuestas = self.encuestas , self.estado == .accepted else {
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        self.fechaInicio = dateFormatter.date(from: fechaInicio)!
        self.fechaFin = dateFormatter.date(from: fechaFin)!
        
        self.estado = EstadoPanel(rawValue: estado)!
    }
    
    static func savePaneles(_ paneles: [Panel]?) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.paneles = paneles
    }
    
}
