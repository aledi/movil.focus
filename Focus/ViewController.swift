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
        
        (self.view.viewWithTag(10) as! UILabel).text = "\(self.appDelegate().user.id!)"
        (self.view.viewWithTag(20) as! UILabel).text = self.appDelegate().user.email
        (self.view.viewWithTag(30) as! UILabel).text = self.appDelegate().user.nombre
    }

}
