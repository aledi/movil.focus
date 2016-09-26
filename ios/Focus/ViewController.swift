//
//  ViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = User.currentUser {
            (self.view.viewWithTag(10) as! UILabel).text = "\(user.id)"
            (self.view.viewWithTag(20) as! UILabel).text = user.email
            (self.view.viewWithTag(30) as! UILabel).text = user.nombre
        }
    }

}
