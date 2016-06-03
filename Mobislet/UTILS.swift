//
//  UTILS.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 17/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit
import Alamofire

// MARK: TYPEALIASES
typealias AlamofireRequestCompleted = (Dictionary<String, AnyObject>? , Error?) -> Void
public typealias Completed = () -> Void

class UTILS {
    
    // MARK: DEVICE TYPE
    
    static var deviceType: DeviceType {
        get {
            
            let screenBounds: CGRect = UIScreen.mainScreen().bounds
            
            /*
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            let appSize = appDel.applicationSize
            */
            if screenBounds.width == 320 {
                if screenBounds.height == 480 {
                    return DeviceType.IPhone4
                } else {
                    return DeviceType.IPhone5
                }
            } else if screenBounds.width == 375 {
                return DeviceType.IPhone6
            } else if screenBounds.width == 414 {
                return DeviceType.IPhone6Plus
            } else {
                return DeviceType.IPad
            }
        }
        
    }
    
    
    static var scaleFactor: CGFloat {
        get {
            let dType = UTILS.deviceType
            var scaleFactor: CGFloat = 1.0
            
            switch dType {
            case DeviceType.IPhone4:
                scaleFactor = 0.73
            case DeviceType.IPhone5:
                scaleFactor = 0.9
            case DeviceType.IPhone6:
                scaleFactor = 1.0
            case DeviceType.IPhone6Plus:
                scaleFactor = 1.1
            case DeviceType.IPad:
                scaleFactor = 1.5
            }
            
            return scaleFactor
        }
    }
    
    static var menuScaleFactor: CGFloat {
        get {
            let dType = UTILS.deviceType
            var scaleFactor: CGFloat = 1.0
            
            switch dType {
            case DeviceType.IPhone4:
                scaleFactor = 0.9
            case DeviceType.IPhone5:
                scaleFactor = 0.95
            case DeviceType.IPhone6:
                scaleFactor = 1.0
            case DeviceType.IPhone6Plus:
                scaleFactor = 1.1
            case DeviceType.IPad:
                scaleFactor = 1.5
            }
            
            return scaleFactor
        }
    }
    
    
    static var fontScaleFactor: CGFloat {
        get {
            let deviceType = UTILS.deviceType
            var scaleFactor: CGFloat = 1.0
            switch deviceType {
            case DeviceType.IPhone4:
                scaleFactor = 0.8
            case DeviceType.IPhone5:
                scaleFactor = 0.9
            case DeviceType.IPhone6:
                scaleFactor = 1.0
            case DeviceType.IPhone6Plus:
                scaleFactor = 1.1
            case DeviceType.IPad:
                scaleFactor = 1.5
            }
            
            return scaleFactor
        }
    }
    

}

