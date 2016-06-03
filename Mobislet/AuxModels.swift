//
//  AuxModels.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 15/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation


enum MobitemType: Int {
    case Default = 0
    case Mall = 1
    case Store = 2
    case Campaign = 3
}


enum MallType: Int {
    case Default = 0
    case ShoppingCenter = 1
    case Street = 2
    case Seasonal = 3
    case Bazaar = 4
}



enum DeviceType: String {
    case IPhone4 = "iphone4" // 320x480
    case IPhone5 // 320x568
    case IPhone6 // 375x667
    case IPhone6Plus // 414x736
    case IPad // Above
}

struct Error {
    
    private var _code: Int
    private var _description: String
    
    var code: Int {
        return _code
    }
    
    var description: String {
        return _description
    }
 
    init(code: Int, description: String) {
        self._code = code
        self._description = description
    }
    
    init(fromErrorCodes: (Int, String)) {
        self._code = fromErrorCodes.0
        self._description = fromErrorCodes.1
    }
    
    mutating func fromErrorCodes(fromErrorCodes:(Int, String)) {
        self._code = fromErrorCodes.0
        self._description = fromErrorCodes.1
    }
    
    
}















