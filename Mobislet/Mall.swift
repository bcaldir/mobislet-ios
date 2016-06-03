//
//  Mall.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 23/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation

class Mall: Mobitem {
    
    private var _mallType: MallType = MallType.Default
    
    private var _address: Address?
    
    private var _cinema: String?
    private var _carParking: String?
    
    private var _latitude: Double?
    private var _longitude: Double?
    private var _altitude: Double?
    private var _distanceToUser: Double?
    
    
    private var _stores: [Store] = [Store]()
    
    var storeCount: Int?
    var campaignCount: Int?
    
    var mallType: MallType {
        return _mallType
    }
    
    var address: Address? {
        return _address
    }
    
    var cinema: String? {
        return _cinema
    }
    
    var carParking: String? {
        return _carParking
    }
    
    var latitude: Double? {
        return _latitude
    }
    
    var longitude: Double? {
        return _longitude
    }
    
    var altitude: Double? {
        return _altitude
    }
    
    var distanceToUser: Double? {
        return _distanceToUser
    }
    
    var stores: [Store] {
        return _stores
    }
    
    convenience init(id: Int, name: String, userLiked: Bool, description: String?, imageNamed: String?) {
        self.init(mallType: MallType.ShoppingCenter, id: id, name: name, userLiked: userLiked, isNew: false, isPopular: false, description: description, imageNamed: imageNamed, address: nil,  cinema: nil, carParking: nil, latitude: nil, longitude: nil, altitude: nil, distanceToUser: nil)
    }
    
    init(mallType: MallType, id: Int, name: String, userLiked: Bool, isNew: Bool, isPopular: Bool, description: String?, imageNamed: String?, address: Address?,  cinema: String?, carParking: String?, latitude: Double?, longitude: Double?, altitude: Double?, distanceToUser: Double?) {
        super.init(mobitemType: MobitemType.Mall, id: id, name: name, userLiked: userLiked, isNew: isNew, isPopular: isPopular, description: description, imageNamed: imageNamed)
        
        self._mallType = mallType
        self._address = address
        self._cinema = cinema
        self._carParking = carParking
        self._latitude = latitude
        self._longitude = longitude
        self._altitude = altitude
        self._distanceToUser = distanceToUser
        
    }
    
    func downloadStores(completion: Completed) {
        
        // For Mall Stores
        DataService.sharedInstance.sendAlamofireRequest(.GET, urlString: "\(DataService.MALL_SERVICE_URL)\(DataService.MALL_GET_URL)/\(self.id)", parameters: nil) { (result, err) -> Void in
            
            if let error = err {
                print("Error in mall stores -> \(error)")
                
            } else if let dict = result {
                
                if let stores = JSONParser.getMallDetailsFrom(dict) {
                    self._stores = stores
                } else {
                }
            }
            
            completion()
        }
        
    }
    
}
