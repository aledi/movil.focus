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
            return UIApplication.sharedApplication().delegate as! AppDelegate
        } set {
            
        }
    }
    
    func dismissSegueSourceViewController(segue: UIStoryboardSegue) {
        if #available(iOS 9, *) {
            return
        }
        
        if (!segue.sourceViewController.isBeingDismissed()) {
            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func presentAlertWithTitle(title: String?, withMessage message: String?, withButtonTitles buttonTitles: [String], withButtonStyles styles: [UIAlertActionStyle], andButtonHandlers handlers: [AlertHandler?]) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        
        for i in 0..<buttonTitles.count {
            alertController.addAction(UIAlertAction(title: buttonTitles[i], style: styles[i], handler: handlers[i]))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
        return alertController
    }
    
}
