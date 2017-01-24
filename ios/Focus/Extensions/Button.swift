//
//  Button.swift
//  Focus
//
//  Created by Eduardo Cristerna on 09/11/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

@IBDesignable class Button: UIButton {
    
    @IBInspectable var normalColor: UIColor = UIColor.white
    @IBInspectable var highlightedColor: UIColor = UIColor.white
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = borderColor?.cgColor
            self.setTitleColor(UIColor.white, for: .highlighted)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? self.highlightedColor : self.normalColor
        }
    }

}
