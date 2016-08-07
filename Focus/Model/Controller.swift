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
    case SAVE_ANSWERS = "SAVE_RESPUESTAS"
}

class Controller {
    
    typealias RequestDidEndHandler = (NSDictionary) -> ()
    
    private static let url = "http://localhost:8888/focus/api/controller.php"
    
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
