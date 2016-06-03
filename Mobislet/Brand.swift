//
//  Brand.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 31/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation

class Brand {
    
    private var _id: Int
    private var _name: String
    private var _imageNamed: String?
    private var _categories = [BrandCategory]()
    
    var id: Int {
        return _id
    }
    
    var name: String {
        return _name
    }
    
    var imageNamed: String? {
        return _imageNamed
    }
    
    var categories: [BrandCategory] {
        return _categories
    }
    
    
    init(id: Int, name: String, imageNamed: String?) {
        self._id = id
        self._name = name
        self._imageNamed = imageNamed
    }
    
    func addBrandCategory(category: BrandCategory) {
        self._categories.append(category)
    }
    
}
