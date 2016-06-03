//
//  Store.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 30/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation

class Store: Mobitem {
    
    private var _campaignCount: Int
    private var _locationInMall: String?
    
    var brand: Brand?
    
    var campaignCount: Int {
        return _campaignCount
    }
    
    var locationInMall: String? {
        return _locationInMall
    }
    
    convenience init(id: Int, name: String, userLiked: Bool, description: String?, imageNamed: String?) {
        self.init(id: id, name: name, userLiked: userLiked, isNew: false, isPopular: false, description: description, imageNamed: imageNamed, campaignCount: 0, locationInMall: nil)
    }
    
    init(id: Int, name: String, userLiked: Bool, isNew: Bool, isPopular: Bool, description: String?, imageNamed: String?, campaignCount: Int, locationInMall: String?) {
        
        self._campaignCount = campaignCount
        self._locationInMall = locationInMall
        
        super.init(mobitemType: MobitemType.Store, id: id, name: name, userLiked: userLiked, isNew: isNew, isPopular: isPopular, description: description, imageNamed: imageNamed)
    }
    
}







