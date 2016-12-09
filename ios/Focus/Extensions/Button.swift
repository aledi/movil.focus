//
//  Button.swift
//  Focus
//
//  Created by Eduardo Cristerna on 09/11/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

@IBDesignable class Button: UIButton {
    
    @IBInspectable var normalColor: UIColor = UIColor.whiteColor()
    @IBInspectable var highlightedColor: UIColor = UIColor.whiteColor()
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = borderColor?.CGColor
            self.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.backgroundColor = highlighted ? self.highlightedColor : self.normalColor
        }
    }

}
