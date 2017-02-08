//
//  UserDefaults.swift
//  Focus
//
//  Created by Eduardo Cristerna on 30/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static func saveUserDefaults(_ user: User) {
        let defaults = UserDefaults.standard
        
        defaults.set(user.id, forKey: "id")
        defaults.set(user.username, forKey: "username")
        defaults.set(user.email, forKey: "email")
        defaults.set(user.nombre, forKey: "nombre")
        defaults.set(user.genero, forKey: "genero")
        defaults.set(user.token, forKey: "token")
        
        defaults.synchronize()
    }
    
    static func retreiveUserDefaults() -> User? {
        let defaults = UserDefaults.standard
        
        guard let id = defaults.object(forKey: "id") as? Int, let username = defaults.object(forKey: "username") as? String, let email = defaults.object(forKey: "email") as? String, let nombre = defaults.object(forKey: "nombre") as? String, let genero = defaults.object(forKey: "genero") as? Int, let _ = defaults.object(forKey: "token") as? String else {
            return nil
        }
        
        return User(id: id, username: username, email: email, nombre: nombre, genero: genero)
    }
    
    static func removeUserDefaults() {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "id")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "nombre")
        defaults.removeObject(forKey: "genero")
        defaults.removeObject(forKey: "token")
        
        defaults.synchronize()
    }
    
}
