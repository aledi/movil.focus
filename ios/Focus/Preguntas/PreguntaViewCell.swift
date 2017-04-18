//
//  PreguntaViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PreguntaViewCell: TableViewCell, UITextViewDelegate {

    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var tituloHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var videoBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var imagen: UIImageView!
    @IBOutlet var imagenHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imagenBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var preguntaLabel: UILabel!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var optionViews: [UIView]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var buttons: [RadioButton]!
    @IBOutlet var heightConstraints: [NSLayoutConstraint]!
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var resetHeightConstraint: NSLayoutConstraint!
    @IBOutlet var resetBottomConstraint: NSLayoutConstraint!
    
    var tipo: TipoPregunta? {
        didSet {
            for button in self.buttons {
                button.multiSelection = tipo == .multiple
                button.ordered = tipo == .ordenamiento
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
            self.videoButton.addTarget(nil, action: videoHandler!, for: .touchUpInside)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Configure
    // -----------------------------------------------------------------------------------------------------------
    
    func configure(for numPregunta: Int) {
        guard let pregunta = self.pregunta else {
            return
        }
        
        self.tituloLabel.text = pregunta.titulo
        self.tituloHeightConstraint.constant = pregunta.titulo.isEmpty ? 0 : 60
        
        self.videoButton.tag = numPregunta
        
        self.videoHeightConstraint.constant = 0
        self.videoBottomConstraint.constant = 0
        self.imagenHeightConstraint.constant = 0
        self.imagenBottomConstraint.constant = 0
        
        if (!pregunta.video.isEmpty) {
            self.videoHeightConstraint.constant = 40
            self.videoBottomConstraint.constant = 15
        }
        
        if let image = pregunta.imagen {
            self.imagenHeightConstraint.constant = 200
            self.imagenBottomConstraint.constant = 15
            self.imagen.image = image
        }
        
        self.preguntaLabel.text = pregunta.pregunta
        
        if (tipo == .abierta) {
            self.textViewHeightConstraint.constant = 100
            self.textViewBottomConstraint.constant = 15
            self.textView.layer.borderWidth = 0.5
            self.textView.layer.borderColor = UIColor.lightGray.cgColor
            self.textView.delegate = self
            self.textView.text = self.pregunta!.respuesta.isEmpty ? "Indique aquí su respuesta..." : self.pregunta!.respuesta
            self.textView.textColor = self.pregunta!.respuesta.isEmpty ? UIColor.lightGray : UIColor.black
            
            for i in 0...19 {
                self.heightConstraints[i].constant = 0
                self.bottomConstraints[i].constant = 0
                self.buttons[i].alpha = 0
            }
            
            self.resetBottomConstraint.constant = 0
            self.resetHeightConstraint.constant = 0
            self.resetButton.alpha = 0
        } else {
            self.textViewHeightConstraint.constant = 0
            self.textViewBottomConstraint.constant = 0
            
            for i in 0..<pregunta.opciones.count {
                self.heightConstraints[i].constant = 50
                self.bottomConstraints[i].constant = 8
                self.labels[i].text = pregunta.opciones[i]
                self.buttons[i].optionNumber = pregunta.selectedOrder[i]
                self.buttons[i].isSelected = pregunta.selectedOptions[i]
                self.buttons[i].alpha = 1.0
            }
            
            for i in pregunta.opciones.count..<20 {
                self.heightConstraints[i].constant = 0
                self.bottomConstraints[i].constant = 0
                self.buttons[i].alpha = 0
            }
            
            if (tipo == .ordenamiento) {
                self.resetBottomConstraint.constant = 8
                self.resetHeightConstraint.constant = 50
                self.resetButton.alpha = 1.0
            } else {
                self.resetBottomConstraint.constant = 0
                self.resetHeightConstraint.constant = 0
                self.resetButton.alpha = 0
            }
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Selection
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func selectOption(_ sender: RadioButton) {
        guard let pregunta = self.pregunta else {
            return
        }
        
        var index = 0
        
        for (i, button) in self.buttons.enumerated() {
            if (button == sender) {
                index = i
                break
            }
        }
        
        switch (self.tipo!) {
        case .abierta:
            break
        case .unica:
            for button in self.buttons {
                button.isSelected = false
            }
            
            sender.isSelected = true
            
            for i in 0...19 {
                pregunta.selectedOptions[i] = self.buttons[i].isSelected
            }
            
            pregunta.respuesta = pregunta.opciones[index]
        case .multiple:
            sender.isSelected = !sender.isSelected
            pregunta.selectedOptions[index] = sender.isSelected
        case .ordenamiento:
            if (!sender.isSelected) {
                sender.optionNumber = pregunta.nextOption
                sender.isSelected = true
                pregunta.respuesta += "\(pregunta.opciones[index])&"
                pregunta.selectedOrder[index] = pregunta.nextOption
                pregunta.selectedOptions[index] = true
                pregunta.nextOption += 1
            }
        default:
            break
        }
    }
    
    @IBAction func resetSelection(_ sender: AnyObject) {
        self.pregunta?.respuesta = ""
        self.pregunta?.nextOption = 1
        
        for button in self.buttons {
            button.isSelected = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.isEmpty) {
            textView.text = "Indique aquí su respuesta..."
            textView.textColor = UIColor.lightGray
            self.pregunta!.respuesta = ""
        } else {
            self.pregunta!.respuesta = textView.text
        }
    }
    
}
