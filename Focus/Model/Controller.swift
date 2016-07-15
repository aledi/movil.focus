//
//  Controller.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Alamofire

enum Actions: String {
    case LOG_IN = "PANELISTA_LOG_IN"
    case GET_PANELES = "GET_PANEL"
}

class Controller {
    
    typealias RequestDidEndHandler = (NSDictionary) -> ()
    
    private static let url = "http://ec2-50-112-177-234.us-west-2.compute.amazonaws.com/focus/api/controller.php"
    
    static func requestForAction(action: Actions, withParameters parameters: [String : AnyObject], withSuccessHandler successHandler: RequestDidEndHandler, andErrorHandler errorHandler: RequestDidEndHandler) {
        var requestParameters = parameters
        requestParameters["action"] = action.rawValue
        
        Alamofire.request(.POST, url, parameters: requestParameters).validate().responseJSON { response in
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
