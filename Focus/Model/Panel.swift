//
//  Panel.swift
//  Focus
//
//  Created by Eduardo Cristerna on 27/07/16.
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
