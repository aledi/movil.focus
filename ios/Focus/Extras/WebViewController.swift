//
//  WebViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 30/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView?
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("FAQ", withExtension:"html")
        self.webView!.loadRequest(NSURLRequest(URL: url!))
    }
    
}
