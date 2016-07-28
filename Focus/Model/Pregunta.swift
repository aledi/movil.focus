//
//  Pregunta.swift
//  Focus
//
//  Created by Eduardo Cristerna on 27/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation

class Pregunta {
    
    var id: Int
    var tipo: Int
    var numPregunta: Int
    var pregunta: String
    var video: String
    var imagen: String
    var op1: String
    var op2: String
    var op3: String
    var op4: String
    var op5: String
    var op6: String
    var op7: String
    var op8: String
    var op9: String
    var op10: String
    
    init(id: Int, tipo: Int, numPregunta: Int, pregunta: String, video: String, imagen: String, op1: String, op2: String, op3: String, op4: String, op5: String, op6: String, op7: String, op8: String, op9: String, op10: String) {
        self.id = id
        self.tipo = tipo
        self.numPregunta = numPregunta
        self.pregunta = pregunta
        self.video = video
        self.imagen = imagen
        self.op1 = op1
        self.op2 = op2
        self.op3 = op3
        self.op4 = op4
        self.op5 = op5
        self.op6 = op6
        self.op7 = op7
        self.op8 = op8
        self.op9 = op9
        self.op10 = op10
    }
    
}
