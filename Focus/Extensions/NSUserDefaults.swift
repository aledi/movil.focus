//
//  NSUserDefaults.swift
//  Focus
//
//  Created by Eduardo Cristerna on 30/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    
    static func saveUserDefaults(user: User) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(user.id, forKey: "id")
        defaults.setObject(user.username, forKey: "username")
        defaults.setObject(user.email, forKey: "email")
        defaults.setObject(user.nombre, forKey: "nombre")
        defaults.setObject(user.token, forKey: "token")
        
        defaults.synchronize()
    }
    
    static func retreiveUserDefaults() -> User? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        guard let id = defaults.objectForKey("id") as? Int, username = defaults.objectForKey("username") as? String, email = defaults.objectForKey("email") as? String, nombre = defaults.objectForKey("nombre") as? String, token = defaults.objectForKey("token") as? String else {
            return nil
        }
        
        return User(id: id, username: username, email: email, nombre: nombre)
    }
    
    static func removeUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.removeObjectForKey("id")
        defaults.removeObjectForKey("username")
        defaults.removeObjectForKey("email")
        defaults.removeObjectForKey("nombre")
        defaults.removeObjectForKey("token")
        
        defaults.synchronize()
    }
    
}
