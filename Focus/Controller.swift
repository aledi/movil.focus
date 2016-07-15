//
//  Controller.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Foundation
import Alamofire

class Controller {
    
    typealias RequestDidEndHandler = (NSDictionary) -> ()
    
    private static let url = "http://ec2-50-112-177-234.us-west-2.compute.amazonaws.com/focus/api/controller.php"
    
    static func request(parameters: [String : AnyObject], withSuccessHandler successHandler: RequestDidEndHandler, andErrorHandler errorHandler: RequestDidEndHandler) {
        Alamofire.request(.POST, url, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                successHandler(response)
            case .Failure(let error):
                errorHandler(["error" : error])
            }
        }
    }
    
}
