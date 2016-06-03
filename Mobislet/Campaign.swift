//
//  Campaign.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 25/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation



/* Campaign
private Long id;
private String name;
private String dscr;
private String image;

private Date startDate;
private Date endDate;
private CampaignStatus cmpStatus;

*/


class Campaign: Mobitem {
    
    private var _status: Int
    private var _statusDescription: String?
    
    private var _category: Int
    private var _categoryDescription: String?
    
    private var _startDate: String
    private var _endDate: String
    
    
    var store: Store?
    
    var status: Int {
        return _status
    }
    
    var statusDescription: String? {
        return _statusDescription
    }

    var category: Int {
        return _category
    }
    
    var categoryDescription: String? {
        return _categoryDescription
    }
    
    var startDate: String {
        return _startDate
    }
    
    var endDate: String {
        return _endDate
    }
    
    
    init(id: Int, name: String, userLiked: Bool, isNew: Bool, isPopular: Bool, description: String?, imageNamed: String?, status: Int, statusDescription: String?, category: Int, categoryDescription: String?, startDate: String , endDate: String) {
        self._status = status
        self._statusDescription = statusDescription
        self._category = category
        self._categoryDescription = categoryDescription
        self._startDate = startDate
        self._endDate = endDate
        
        super.init(mobitemType: MobitemType.Campaign, id: id, name: name, userLiked: userLiked, isNew: isNew, isPopular: isPopular, description: description, imageNamed: imageNamed)

    }
    
}