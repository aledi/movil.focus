//
//  PreguntaViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PreguntaViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var preguntaLabel: UILabel!
    
    @IBOutlet var imagen: UIImageView!
    @IBOutlet var imagenHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imagenBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var optionViews: [UIView]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var buttons: [RadioButton]!
    @IBOutlet var heightConstraints: [NSLayoutConstraint]!
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    
    var tipo: TipoPregunta? {
        didSet {
            for button in self.buttons {
                button.multiSelection = (tipo == .Multiple)
            }
        }
    }
    var pregunta: Pregunta? {
        didSet {
            guard let pregunta = self.pregunta else {
                return
            }
            
            self.tipo = TipoPregunta(rawValue: pregunta.tipo)!
        }
    }
    
    var videoHandler: Selector? {
        didSet {
            for button in self.buttons {
                button.addTarget(nil, action: videoHandler!, forControlEvents: .TouchUpInside)
            }
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Configure
    // -----------------------------------------------------------------------------------------------------------
    
    func configureForPregunta() {
        guard let pregunta = self.pregunta else {
            return
        }
        
        self.preguntaLabel.text = pregunta.pregunta
        
        self.imagenHeightConstraint.constant = 0
        self.imagenBottomConstraint.constant = 0
        
        if (pregunta.imagen != "") {
            if let url =  NSURL(string: pregunta.imagen), data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                self.imagenHeightConstraint.constant = 200
                self.imagenBottomConstraint.constant = 15
                self.imagen.image = image
            }
        }
        
        if (tipo == .Abierta) {
            self.textViewHeightConstraint.constant = 100
            self.textViewBottomConstraint.constant = 15
            self.textView.layer.borderWidth = 0.5
            self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.textView.delegate = self
            self.textView.text = self.pregunta!.respuesta == "" ? "Indique aquí su respuesta..." : self.pregunta!.respuesta
            self.textView.textColor = self.pregunta!.respuesta == "" ? UIColor.lightGrayColor() : UIColor.blackColor()
            
            for i in 0...9 {
                self.heightConstraints[i].constant = 0
                self.bottomConstraints[i].constant = 0
                self.buttons[i].alpha = 0
            }
        } else {
            self.textViewHeightConstraint.constant = 0
            self.textViewBottomConstraint.constant = 0
            
            for i in 0..<pregunta.opciones.count {
                self.heightConstraints[i].constant = 50
                self.bottomConstraints[i].constant = 8
                self.labels[i].text = pregunta.opciones[i]
                self.buttons[i].selected = pregunta.selectedOptions[i]
                self.buttons[i].alpha = 1.0
            }
            
            for i in pregunta.opciones.count..<10 {
                self.heightConstraints[i].constant = 0
                self.bottomConstraints[i].constant = 0
                self.buttons[i].alpha = 0
            }
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Selection
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func selectOption(sender: RadioButton) {
        guard let pregunta = self.pregunta else {
            return
        }
        
        let index = self.buttons.indexOf(sender)!
        
        switch (self.tipo!) {
        case .Abierta:
            break
        case .Unica:
            for button in self.buttons {
                button.selected = false
            }
            
            sender.selected = true
            
            for i in 0...9 {
                pregunta.selectedOptions[i] = self.buttons[i].selected
            }
            
            pregunta.respuesta = pregunta.opciones[index]
        case .Multiple:
            sender.selected = !sender.selected
            pregunta.selectedOptions[index] = sender.selected
        case .Ordenamiento:
            break
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.textColor == UIColor.lightGrayColor()) {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text.isEmpty) {
            textView.text = "Indique aquí su respuesta..."
            textView.textColor = UIColor.lightGrayColor()
            self.pregunta!.respuesta = ""
        } else {
            self.pregunta!.respuesta = textView.text
        }
    }
    
}
