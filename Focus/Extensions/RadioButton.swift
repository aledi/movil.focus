//
//  RadioButton.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    
    @IBInspectable override var selected: Bool {
        didSet {
            let image = selected ? UIImage(named: "SelectedButton") : UIImage(named: "UnselectedButton")
            self.setImage(image, forState: .Normal)
        }
    }
    
}
