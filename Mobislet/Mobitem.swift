//
//  Mobitem.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 15/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation

/* MALL
private Long id;
private String name;
private String description;
private String image;

private Address address;
private String addressDescription;
private BigDecimal latitude;
private BigDecimal longitude;
private BigDecimal altitude;
private String cinema;
private String carParking;
private int mallType;
*/

/* Store
private Long id;
private String name;
private String dscr;
private String image;

private Address address;
private String addressDscr;
private BigDecimal latitude;
private BigDecimal longitude;
private BigDecimal altitude;
private Brand brand;
private Mall mall;

*/

/* Campaign
private Long id;
private String name;
private String dscr;
private String image;

private Date startDate;
private Date endDate;
private CampaignStatus cmpStatus;

*/

class Mobitem {

    private var _mobitemType: MobitemType = MobitemType.Default
    
    private var _id: Int
    private var _name: String!
    private var _description: String?
    private var _imageNamed: String?

    private var _isNew: Bool = false
    private var _isPopular: Bool = false
    
    private var _userLiked: Bool = false

    
    var mobitemType: MobitemType {
        return _mobitemType
    }

    var id: Int {
        return _id
    }
    var name: String {
            return _name
    }
    
    var description: String? {
        return _description
    }
    
    var imageNamed: String? {
        return _imageNamed
    }
    
    var isNew: Bool {
        return _isNew
    }
    
    var isPopular: Bool {
        return _isPopular
    }
    
    var userLiked: Bool {
        return _userLiked
    }
    
    convenience init(mobitemType: MobitemType, id: Int, name: String) {
        self.init(mobitemType: mobitemType, id: id, name: name, userLiked: false, isNew: false, isPopular: false, description: nil, imageNamed: nil)
    }
    
    init(mobitemType: MobitemType, id: Int, name: String, userLiked: Bool, isNew: Bool, isPopular: Bool, description: String?, imageNamed: String?) {
        self._mobitemType = mobitemType
        self._id = id
        self._name = name
        self._userLiked = userLiked
        self._isNew = isNew
        self._isPopular = isPopular
        self._description = description
        self._imageNamed = imageNamed
    }
    
    // Methods
    func setUserLike(like: Bool) {
        self._userLiked = like
    }

}