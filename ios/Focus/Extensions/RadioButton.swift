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
    
    var multiSelection: Bool = false
    
    @IBInspectable override var selected: Bool {
        didSet {
            let image = selected ? UIImage(named: self.multiSelection ? "MarkedButton" : "SelectedButton") : UIImage(named: self.multiSelection ? "UnmarkedButton" : "UnselectedButton")
            self.setImage(image, forState: .Normal)
        }
    }
    
}
