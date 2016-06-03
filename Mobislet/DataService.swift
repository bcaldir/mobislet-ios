//
//  DataService.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 23/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    
    //private let BASE_URL = "http://localhost:8080/JerseyMobislet/rest"
    private let BASE_URL = "http://jerseymobislet.herokuapp.com/rest"
    
    static let MALL_SERVICE_URL = "/service/malls"
    static let STORE_SERVICE_URL = "/service/stores"
    static let BRAND_SERVICE_URL = "/service/brands"
    static let CAMPAIGN_SERVICE_URL = "/service/campaigns"
    static let DISCOVERY_SERVICE_URL = "/service/discovery"
    static let USER_SERVICE_URL = "/service/users"

    static let MALL_GET_URL = "/getMall"
    static let MALLS_POPULAR_GET_URL = "/getPopularMalls"
    static let MALLS_NEAREST_GET_URL = "/getNearestMalls"
    static let MALLS_LIKED_GET_URL = "/getLikedMalls"

    static let STORE_GET_URL = "/getStore"
    
    static let BRAND_GET_URL = "/getBrand"
    static let BRANDS_POPULAR_GET_URL = "/getPopularBrands"
   
    static let CAMPAGINS_NEW_GET_URL = "/getNewCampaigns"
    static let CAMPAGINS_POPULAR_GET_URL = "/getPopularCampaigns"
    static let CAMPAGINS_STORE_GET_URL = "/getCampaignsByStore"
    static let CAMPAGIN_GET_URL = "/getCampaign"
    
    static let DISCOVERY_GET_URL = "/getDiscovery"
    
    static let USER_ADD_POST_URL = "/addUser"
    static let USER_GET_URL = ""
    static let USER_LIKED_MALLS_GET_URL = "/malls"
    static let USER_LIKED_BRANDS_GET_URL = "/brands"
    static let USER_LIKED_CAMPAIGNS_GET_URL = "/campaigns"
    
    /*POST /rest/service/users/{user-id}/malls/{mall-id}
    POST /rest/service/users/{user-id}/brands/{brand-id}
    POST /rest/service/users/{user-id}/campaigns/{campaign-id}*/
    
    
    static let sharedInstance = DataService()
    static var imageCache = NSCache()

    func sendAlamofireRequest(method: Alamofire.Method, urlString: String, parameters: [String : NSObject]?, completionHandler: AlamofireRequestCompleted) {
        
        let url = "\(BASE_URL)\(urlString)"
        
        let headers = [
            //             "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Content-Type": "application/json",
            "Connection": "close"
        ]

        let request = Alamofire.request(method, url, parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
        
        request.responseJSON { response in

            let result = response.result
            
            if let error = result.error {
                if (error.code == 0){
                    print("no error")
                } else {
                
                    if error.code == ERRORCODES.ALAMOFIRE_SERVER_UNREACHABLE.0 {
                        completionHandler(nil, Error(fromErrorCodes: ERRORCODES.ALAMOFIRE_SERVER_UNREACHABLE))
                    }
                }
            }
                
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let status = dict["status"] as? Int {
                    
                    if status == 1 { // Request returned working data
                        
                        completionHandler(dict, nil)
                        
                    } else { // En error occured
                        
                        var error = Error(fromErrorCodes: ERRORCODES.DEFAULT)
                        
                        if let errorDetails = dict["error"] as? Dictionary<String, AnyObject> {
                            
                            print(errorDetails)
                            if let errorCode = errorDetails["code"] as? Int {
                                if let errorDesc = errorDetails["message"] as? String {
                                    error.fromErrorCodes((errorCode, errorDesc))
                                }
                            }
                        }
                        completionHandler(nil, error)
                    }
                } else {
                    
                    let error = Error(fromErrorCodes: ERRORCODES.UNKNOWNRESPONSETYPE)
                    completionHandler(nil, error)
                }
            }
        }
    }
}

