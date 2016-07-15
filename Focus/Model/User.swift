//
//  User.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class User {
    
    var id: Int
    var email: String
    var nombre: String
    var paneles: [Panel]
    
    init(id: Int, email: String, nombre: String) {
        self.id = id
        self.email = email
        self.nombre = nombre
        self.paneles = [Panel]()
    }
    
    static func saveUser(user: User) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.user = user
    }
    
}