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
    var username: String
    var email: String
    var nombre: String
    var genero: Int
    var token: String = ""
    
    init(id: Int, username: String, email: String, nombre: String, genero: Int) {
        self.id = id
        self.username = username
        self.email = email
        self.nombre = nombre
        self.genero = genero
    }
    
    static func saveUser(user: User) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.user = user
    }
    
    static var currentUser: User? {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.user
    }
    
    var firstName: String {
        return self.nombre.componentsSeparatedByString(" ")[0]
    }
    
    var isMale: Bool {
        return self.genero == 0
    }
    
}
