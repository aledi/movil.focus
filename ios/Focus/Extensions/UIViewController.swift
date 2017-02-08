//
//  UIViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias AlertHandler = (UIAlertAction) -> Void
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        } set {
            
        }
    }
    
    func dismissSegueSourceViewController(_ segue: UIStoryboardSegue) {
        if #available(iOS 9, *) {
            return
        }
        
        if (!segue.source.isBeingDismissed) {
            segue.source.dismiss(animated: true, completion: nil)
        }
    }
    
    @discardableResult func presentAlertWithTitle(_ title: String?, withMessage message: String?, withButtonTitles buttonTitles: [String], withButtonStyles styles: [UIAlertActionStyle], andButtonHandlers handlers: [AlertHandler?]) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        for i in 0..<buttonTitles.count {
            alertController.addAction(UIAlertAction(title: buttonTitles[i], style: styles[i], handler: handlers[i]))
        }
        
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
}
