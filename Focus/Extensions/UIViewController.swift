//
//  UIViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 13/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func dismissSegueSourceViewController(segue: UIStoryboardSegue) {
        if #available(iOS 9, *) {
            return
        }
        
        if (!segue.sourceViewController.isBeingDismissed()) {
            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
