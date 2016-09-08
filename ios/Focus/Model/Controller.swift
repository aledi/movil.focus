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
    case GET_DATA = "GET_MOBILE_DATA"
    case START_SURVEY = "START_ENCUESTA"
    case SAVE_ANSWERS = "SAVE_RESPUESTAS"
    case REGISTER_DEVICE = "REGISTER_DEVICE"
    case UNREGISTER_DEVICE = "UNREGISTER_DEVICE"
    case PRIVACY_POLICY = "PRIVACY_POLICY"
}

class Controller {
    
    typealias RequestDidEndHandler = (NSDictionary) -> ()
    
    private static let url = "http://ec2-52-26-0-111.us-west-2.compute.amazonaws.com/focus/api/controller.php"
    
    static func requestForAction(action: Actions, withParameters parameters: [String : AnyObject], withSuccessHandler successHandler: RequestDidEndHandler?, andErrorHandler errorHandler: RequestDidEndHandler? = nil) {
        var requestParameters = parameters
        requestParameters["action"] = action.rawValue
        
        Alamofire.request(.POST, url, parameters: requestParameters).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                
                if let successHandler = successHandler {
                    successHandler(response)
                }
            case .Failure(let error):
                if let errorHandler = errorHandler {
                    errorHandler(["error" : error])
                }
            }
        }
    }
    
}
