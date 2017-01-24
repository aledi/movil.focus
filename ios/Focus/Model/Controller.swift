//
//  Controller.swift
//  Focus
//
//  Created by Eduardo Cristerna on 14/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import Alamofire

enum Actions: String {
    case logIn = "PANELISTA_LOG_IN"
    case getData = "GET_MOBILE_DATA"
    case startSurvey = "START_ENCUESTA"
    case saveAnswers = "SAVE_RESPUESTAS"
    case registerDevice = "REGISTER_DEVICE"
    case unregisterDevice = "UNREGISTER_DEVICE"
    case privacyPolicy = "PRIVACY_POLICY"
    case registerUser = "ALTA_PANELISTA"
    case changePassword = "CHANGE_PANELISTA_PASSWORD"
    case forgotPassword = "FORGOT_PANELISTA_PASSWORD"
    case getHistory = "GET_HISTORIAL"
    case invitationReponse = "INVITATION_RESPONSE"
}

class Controller {
    
    typealias RequestDidEndHandler = (NSDictionary) -> ()
    
    static fileprivate let alamofireManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    fileprivate static let baseURL = "http://focusestudios.mx/paneles/"
//    private static let baseURL = "http://tenorio94.tk/focus/"
//    private static let baseURL = "http://192.168.1.68:8888/focus/"
    
    fileprivate static let apiURL = Controller.baseURL + "api/controller.php"
    
    static let videosURL = Controller.baseURL + "resources/videos/"
    static let imagesURL = Controller.baseURL + "resources/images/"
    
    static func request(for action: Actions, withParameters parameters: [String : Any], withSuccessHandler successHandler: RequestDidEndHandler?, andErrorHandler errorHandler: RequestDidEndHandler? = nil) {
        var requestParameters = parameters
        requestParameters["action"] = action.rawValue
        
        Alamofire.request(apiURL, method: .post, parameters: requestParameters).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                if let successHandler = successHandler {
                    successHandler(JSON as! NSDictionary)
                }
            case .failure(let error):
                if let errorHandler = errorHandler {
                    errorHandler(["error" : error])
                }
            }
        }
    }
    
}
