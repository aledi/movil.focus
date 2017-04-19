//
//  WelcomeViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 07/09/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var salutLabel: UILabel!
    @IBOutlet var firstParagraphLabel: UILabel!
    
    let firstPart = "Su inscripción a Crowd-It ha sido confirmada. A partir de ahora queda"
    let secondPart = "para participar en nuestros estudios y compartir su opinión."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = (User.currentUser?.isMale ?? true) ? "Bienvenido" : "Bienvenida"
        self.welcomeLabel.text = "¡\(self.navigationItem.title!) a la app de panelistas Crowd-It!"
        self.firstParagraphLabel.text = (User.currentUser?.isMale ?? true) ? "\(self.firstPart) registrado \(self.secondPart)" : "\(self.firstPart) registrada \(self.secondPart)"
        
        var salut = (User.currentUser?.isMale ?? true) ? "Estimado" : "Estimada"
        
        if let nombre = User.currentUser?.firstName {
            salut += " \(nombre)"
        } else {
            salut += (User.currentUser?.isMale ?? true) ? "Usuario" : "Usuaria"
        }
        
        self.salutLabel.text = salut + ","
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}
