//
//  ProfileViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 30/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

enum Sections: Int {
    case User
    case Panels
    case Contact
    case LogOut
}

class ProfileViewController: UITableViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var panelsLabel: UILabel!
    @IBOutlet var encuestasLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = User.currentUser, paneles = self.appDelegate().paneles else {
            return
        }
        
        var pending = 0
        
        for panel in paneles {
            pending += panel.encuestasPendientes
        }
        
        self.nameLabel.text = user.nombre
        self.emailLabel.text = user.email
        self.panelsLabel.text = "\(paneles.count)"
        self.encuestasLabel.text = "\(pending)"
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "logOut") {
            NSUserDefaults.removeUserDefaults()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch Sections(rawValue: indexPath.section)! {
        case .Contact:
            break
        case .LogOut:
            let alertController = UIAlertController(
                title: "Cerrar Sesión",
                message: "La próxima vez que abra la aplicación se le pedirán sus datos de acceso.",
                preferredStyle: .Alert
            )
            
            alertController.addAction(UIAlertAction(title: "Cerrar", style: .Destructive, handler: { (action) in
                self.performSegueWithIdentifier("logOut", sender: nil)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
}
