//
//  LogInViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    func didFinishRequest(response: NSDictionary) {
        if (response.objectForKey("status")! as! String == "SUCCESS") {
            self.appDelegate().user.id = response.objectForKey("id") as? Int
            self.appDelegate().user.email = response.objectForKey("email") as? String
            self.appDelegate().user.nombre = response.objectForKey("nombre") as? String
            
            self.performSegueWithIdentifier("logIn", sender: self)
        } else {
            self.feedbackLabel.hidden = false
            self.feedbackLabel.text = "Usuario o contraseña incorrectos"
        }
    }

    @IBAction func logIn(sender: AnyObject) {
        let url = "http://ec2-50-112-177-234.us-west-2.compute.amazonaws.com/focus/api/controller.php"
        let parameters: [String : AnyObject] = [
            "action" : "PANELISTA_LOG_IN",
            "email" : self.emailText.text!,
            "password" : self.passwordText.text!
        ]
        
        Alamofire.request(.POST, url, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                self.didFinishRequest(response)
            case .Failure(let error):
                self.feedbackLabel.hidden = false
                self.feedbackLabel.text = "Servidor No Disponible"
                print(error)
            }
        }
    }
    
}
