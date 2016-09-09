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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = (User.currentUser?.isMale ?? true) ? "Bienvenido" : "Bienvenida"
        self.welcomeLabel.text = "¡\(self.navigationItem.title!) a la app de panelistas Focus!"
        
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
        
        self.scrollView.setContentOffset(CGPointZero, animated: false)
    }
    
}
