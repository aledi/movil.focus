//
//  PreguntaMatrizViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PreguntaMatrizViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var tituloHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var videoBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var imagen: UIImageView!
    @IBOutlet var imagenHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imagenBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var preguntaLabel: UILabel!
    
    @IBOutlet var optionViews: [UIView]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var heightConstraints: [NSLayoutConstraint]!
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    
    var optionsPickers: [UIPickerView] = []
    
    var pregunta: Pregunta?
    var videoHandler: Selector? {
        didSet {
            self.videoButton.addTarget(nil, action: videoHandler!, forControlEvents: .TouchUpInside)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Configure
    // -----------------------------------------------------------------------------------------------------------
    
    func configureForPregunta(numPregunta: Int) {
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
        
        self.optionsPickers.removeAll()
        
        for i in 0..<pregunta.subPreguntas.count {
            self.heightConstraints[i].constant = 50
            self.bottomConstraints[i].constant = 8
            self.labels[i].text = pregunta.subPreguntas[i]
            
            let selectedOption = pregunta.selectedSubPreguntas[i]
            
            if (selectedOption != -1) {
                self.textFields[i].text = pregunta.opciones[selectedOption]
            } else {
                self.textFields[i].text = nil
            }
            
            let newPicker = UIPickerView()
            
            newPicker.delegate = self
            newPicker.dataSource = self
            self.textFields[i].alpha = 1.0
            self.textFields[i].inputView = newPicker
            self.optionsPickers.append(newPicker)
        }
        
        for i in pregunta.subPreguntas.count..<20 {
            self.heightConstraints[i].constant = 0
            self.bottomConstraints[i].constant = 0
            self.textFields[i].alpha = 0
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - UIPickerDelegate/DataSource
    // -----------------------------------------------------------------------------------------------------------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pregunta?.opciones.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pregunta!.opciones[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var index = 0
        
        for i in 0..<self.optionsPickers.count {
            if (self.optionsPickers[i] == pickerView) {
                index = i
                break
            }
        }
        
        self.textFields[index].text = self.pregunta!.opciones[row]
        self.pregunta!.selectedSubPreguntas[index] = row
    }
    
}
