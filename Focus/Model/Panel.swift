//
//  Panel.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation
import UIKit

class Panel {
    
    var id: Int
    var nombre: String
    var fechaInicio: NSDate
    var fechaFin: NSDate
    var encuestas: [Encuesta]?
    
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
    
    init(id: Int, nombre: String, fechaInicio: String, fechaFin: String) {
        self.id = id
        self.nombre = nombre
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        self.fechaInicio = dateFormatter.dateFromString(fechaInicio)!
        self.fechaFin = dateFormatter.dateFromString(fechaInicio)!
    }
    
    static func savePaneles(paneles: [Panel]?) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.paneles = paneles
    }
    
}
