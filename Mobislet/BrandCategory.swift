//
//  BrandCategory.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 09/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation

class BrandCategory {
    
    private var _code: Int
    private var _name: String
    private var _description: String?
    
    var code: Int {
        return _code
    }
    
    var name: String {
        return _name
    }
    
    var description: String? {
        return _description
    }
    
    init(code: Int, name: String, description: String?) {
        self._code = code
        self._name = name
        self._description = description
    }
    
}










