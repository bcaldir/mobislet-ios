//
//  JSONParser.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 25/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation

class JSONParser {
    
    static func getMallListFrom(dict:  Dictionary<String, AnyObject>) -> [Mall]? {
        
        var mallList: [Mall]?
        
        if let datas = dict["data"] as? [Dictionary<String, AnyObject>]  where datas.count > 0 {
            
            mallList = [Mall]()
            
            for i in 0..<datas.count {
                let data = datas[i]
                
                print(data)
                
                var mallId: Int!
                
                var mallName: String!
                var mallDescription: String = ""
                var mallImageNamed: String?
                
                var mallNew: Bool = false
                var mallPopular: Bool = false
                
                var mallCinema: String?
                var mallCarParking: String?
                
                var mallLatitude: Double?
                var mallLongitude: Double?
                var mallAltitude: Double?
                var mallDistanceToUser: Double?
                
                var mallStoreCount: Int?
                var mallCampaignCount: Int?
                
                
                if let id = data["id"] as? Int {
                    mallId = id
                } else {
                    continue
                }
                
                if let name = data["name"] as? String {
                    mallName = name
                } else {
                    continue
                }
                
                if let desc = data["description"] as? String {
                    
                    mallDescription = desc
                }
                
                if let image = data["image"] as? String {
                    
                    mallImageNamed = image
                }
                
                
                if let new = data["new"] as? Int {
                    if new == 1 {
                        mallNew = true
                    }
                }
                
                if let popular = data["popular"] as? Int {
                    if popular == 1 {
                        mallPopular = true
                    }
                }
                
                if let cinema = data["cinema"] as? String {
                    mallCinema = cinema
                }
                
                if let carParking = data["carParking"] as? String {
                    mallCarParking = carParking
                }
                
                if let latitude = data["latitude"] as? Double {
                    mallLatitude = latitude
                }
                
                if let longitude = data["longitude"] as? Double {
                    mallLongitude = longitude
                }
                
                if let altitude = data["altitude"] as? Double {
                    mallAltitude = altitude
                }
                
                
                if let distance = data["distance"] as? Double {
                    mallDistanceToUser = distance
                }
                
                if let storeCount = data["storeCount"] as? Int {
                    mallStoreCount = storeCount
                }
                
                if let campaignCount = data["campaignCount"] as? Int {
                    mallCampaignCount = campaignCount
                }
                
                let tempMall = Mall(mallType: MallType.ShoppingCenter, id: mallId, name: mallName, userLiked: false, isNew: mallNew, isPopular: mallPopular, description: mallDescription, imageNamed: mallImageNamed, address: nil, cinema: mallCinema, carParking: mallCarParking, latitude: mallLatitude, longitude: mallLongitude, altitude: mallAltitude, distanceToUser: mallDistanceToUser)
                
                tempMall.storeCount = mallStoreCount
                tempMall.campaignCount = mallCampaignCount
                
                mallList!.append(tempMall)
            }
        }
        
        if mallList?.count > 0 {
            return mallList
        } else {
            return nil
        }
    }
    
    static func getCampaignListFrom(dict:  Dictionary<String, AnyObject>) -> [Campaign]? {
        
        var campaignList: [Campaign]?
        
        if let datas = dict["data"] as? [Dictionary<String, AnyObject>]  where datas.count > 0 {
            
            
            campaignList = [Campaign]()
            
            for i in 0..<datas.count {
                let data = datas[i]
                
                print(data)
                
                var campaignId: Int!
                
                var campaignName: String!
                var campaignDescription: String = ""
                var campaignImageNamed: String?
                
                var campaignNew: Bool = false
                var campaignPopular: Bool = false
                
                
                var campaignStatus:Int!
                var campaignStatusDescription: String?
                var campaignCategory: Int!
                var campaignCategoryDescription: String?
                var campaignStartDate: String
                var campaignEndDate: String
                
                var campaignStoreId: Int?
                var campaignStoreName: String?
                var campaignStoreImageNamed: String?
                
                
                if let id = data["id"] as? Int {
                    campaignId = id
                } else {
                    continue
                }
                
                if let name = data["name"] as? String {
                    campaignName = name
                } else {
                    continue
                }
                
                if let desc = data["description"] as? String {
                    campaignDescription = desc
                }
                
                if let image = data["image"] as? String {
                    campaignImageNamed = image
                }
                
                
                if let new = data["new"] as? Int {
                    if new == 1 {
                        campaignNew = true
                    }
                }
                
                if let popular = data["popular"] as? Int {
                    if popular == 1 {
                        campaignPopular = true
                    }
                }
                
                if let status = data["status"] as? Int {
                    campaignStatus = status
                } else {
                    continue
                }
                
                if let statusDescription = data["statusDescription"] as? String {
                    campaignStatusDescription = statusDescription
                }
                
                
                if let category = data["category"] as? Int {
                    campaignCategory = category
                } else {
                    continue
                }
                
                if let categoryDescription = data["categoryDescription"] as? String {
                    campaignCategoryDescription = categoryDescription
                }
                
                
                if let startDate = data["startDate"] as? String {
                    campaignStartDate = startDate
                } else {
                    campaignStartDate = "1900-01-01"
                }
                
                
                if let endDate = data["endDate"] as? String {
                    campaignEndDate = endDate
                } else {
                    campaignEndDate = "1900-01-01"
                }
                
                if let storeId = data["storeId"] as? Int {
                    campaignStoreId = storeId
                }
                
                
                if let storeName = data["storeName"] as? String {
                    campaignStoreName = storeName
                }
                
                if let storeImage = data["storeImage"] as? String {
                    campaignStoreImageNamed = storeImage
                }
                
                
                let tempCampaign = Campaign(id: campaignId, name: campaignName, userLiked: false, isNew: campaignNew, isPopular: campaignPopular, description: campaignDescription, imageNamed: campaignImageNamed, status: campaignStatus, statusDescription: campaignStatusDescription, category: campaignCategory, categoryDescription: campaignCategoryDescription, startDate: campaignStartDate, endDate: campaignEndDate)
                
                if campaignStoreId != nil && campaignStoreName != nil {
                    tempCampaign.store = Store(id: campaignStoreId!, name: campaignStoreName!, userLiked: false, description: nil, imageNamed: campaignStoreImageNamed)
                    
                }
                
                campaignList!.append(tempCampaign)
            }
            
        }
        
        if campaignList?.count > 0 {
            return campaignList
        } else {
            return nil
        }
        
    }
    
    
    
    static func getStoreListFrom(dict:  Dictionary<String, AnyObject>) -> [Store]? {
        
        var storeList: [Store]?
        
        if let datas = dict["data"] as? [Dictionary<String, AnyObject>]  where datas.count > 0 {
            
            storeList = [Store]()
            
            for i in 0..<datas.count {
                let data = datas[i]
                
                print(data)
                
                
                var storeId: Int!
                
                var storeName: String!
                var storeDescription: String = ""
                var storeImageNamed: String?
                
                var storeNew: Bool = false
                var storePopular: Bool = false
                
                var storeCampaignCount: Int = 0
                
                var storeBrandId: Int?
                var storeBrandName: String?
                var storeBrandImageNamed: String?
                
                
                if let id = data["id"] as? Int {
                    storeId = id
                } else {
                    continue
                }
                
                if let name = data["name"] as? String {
                    storeName = name
                } else {
                    continue
                }
                
                if let desc = data["description"] as? String {
                    storeDescription = desc
                }
                
                if let image = data["image"] as? String {
                    storeImageNamed = image
                }
                
                if let new = data["new"] as? Int {
                    if new == 1 {
                        storeNew = true
                    }
                }
                
                if let popular = data["popular"] as? Int {
                    if popular == 1 {
                        storePopular = true
                    }
                }
                
                if let campaignCount = data["campaignCount"] as? Int {
                    storeCampaignCount = campaignCount
                }
                
                if let brandId = data["brandId"] as? Int {
                    storeBrandId = brandId
                }
                
                if let brandName = data["brandName"] as? String {
                    storeBrandName = brandName
                }
                
                if let brandImage = data["brandImage"] as? String {
                    storeBrandImageNamed = brandImage
                }
                
                let tempStore = Store(id: storeId, name: storeName, userLiked: false, isNew: storeNew, isPopular: storePopular, description: storeDescription, imageNamed: storeImageNamed, campaignCount: storeCampaignCount, locationInMall: nil)
                
                if storeBrandId != nil && storeBrandName != nil {
                    tempStore.brand = Brand(id: storeBrandId!, name: storeBrandName!, imageNamed: storeBrandImageNamed)
                }
                
                
                storeList!.append(tempStore)
            }
        }
        
        if storeList?.count > 0 {
            return storeList
        } else {
            return nil
        }
        
    }
    
    
    
    static func getMallDetailsFrom(dict:  Dictionary<String, AnyObject>) -> [Store]? {
        
        var storeList: [Store]?
        
        if let datas = dict["data"] as? [Dictionary<String, AnyObject>]  where datas.count > 0 {
            
            // print(datas)
            
            for data in datas {
                
                if let stores = data["storeList"] as? [Dictionary<String, AnyObject>]  where stores.count > 0 {
                    
                    storeList = [Store]()
                    
                    for store in stores {
                        
                        print(store)
                        
                        var storeId: Int!
                        var storeName: String!
                        var storeDescription: String = ""
                        var storeImageNamed: String?
                        
                        var storeNew: Bool = false
                        var storePopular: Bool = false
                        
                        var storeCampaignCount: Int = 0
                        var storeLocationInMall: String?
                        
                        var storeBrandId: Int?
                        var storeBrandName: String?
                        var storeBrandImageNamed: String?
                        
                        
                        if let id = store["id"] as? Int {
                            storeId = id
                        } else {
                            continue
                        }
                        
                        if let name = store["name"] as? String {
                            storeName = name
                        } else {
                            continue
                        }
                        
                        if let desc = store["description"] as? String {
                            storeDescription = desc
                        }
                        
                        if let image = store["image"] as? String {
                            storeImageNamed = image
                        }
                        
                        
                        if let new = store["new"] as? Int {
                            if new == 1 {
                                storeNew = true
                            }
                        }
                        
                        if let popular = store["popular"] as? Int {
                            if popular == 1 {
                                storePopular = true
                            }
                        }
                        
                        if let campaignCount = store["campaignCount"] as? Int {
                            storeCampaignCount = campaignCount
                        }
                        
                        if let locationInMall = store["locationInMall"] as? String {
                            storeLocationInMall = locationInMall
                        }
                        
                        if let brandId = store["brandId"] as? Int {
                            storeBrandId = brandId
                        }
                        
                        if let brandName = store["brandName"] as? String {
                            storeBrandName = brandName
                        }
                        
                        if let brandImage = store["brandImage"] as? String {
                            storeBrandImageNamed = brandImage
                        }
                        
                        let tempStore = Store(id: storeId, name: storeName, userLiked: false, isNew: storeNew, isPopular: storePopular, description: storeDescription, imageNamed: storeImageNamed, campaignCount: storeCampaignCount, locationInMall: storeLocationInMall)
                        
                        if storeBrandId != nil && storeBrandName != nil {
                            
                            let storeBrand = Brand(id: storeBrandId!, name: storeBrandName!, imageNamed: storeBrandImageNamed)
                            
                            
                            if let brandCategories = store["brandCategories"] as? [Dictionary<String, AnyObject>]  where brandCategories.count > 0 {
                                
                                print(brandCategories)
                                
                                for category in brandCategories {
                                    
                                    if let catCode = category["code"] as? Int, catName = category["name"] as? String {
                                        
                                        let catDescription = category["description"] as? String
                                        
                                        storeBrand.addBrandCategory(BrandCategory(code: catCode, name: catName, description: catDescription))
                                    }
                                }
                            }
                            
                            tempStore.brand = storeBrand
                        }
                        
                        storeList!.append(tempStore)
                    }
                }
            }
        }
        
        if storeList?.count > 0 {
            return storeList
        } else {
            return nil
        }
        
    }
    
}
