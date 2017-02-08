//
//  PrivacyPolicyViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 06/09/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Controller.request(for: .privacyPolicy, withParameters: [:], withSuccessHandler: { (response) in
            if let content = response["content"] as? String {
                self.contentTextView.text = content
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.contentTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}
