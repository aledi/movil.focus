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
    
    var optionNumber: Int = 0
    var multiSelection: Bool = false
    var ordered: Bool = false
    
    @IBInspectable override var isSelected: Bool {
        didSet {
            if (self.ordered) {
                let image = UIImage(named: isSelected ? "Selected\(self.optionNumber)" : "UnmarkedButton")
                self.setImage(image, for: .normal)
            } else {
                let image = isSelected ? UIImage(named: self.multiSelection ? "MarkedButton" : "SelectedButton") : UIImage(named: self.multiSelection ? "UnmarkedButton" : "UnselectedButton")
                self.setImage(image, for: .normal)
            }
        }
    }
    
}
