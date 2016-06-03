//
//  CONSTANTS.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 14/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit


class CONSTANTS {
    
    // MARK: SEGUES
    static let STORYBOARDID_DISCOVERY: String = "discoveryNavigationSBID"
    static let STORYBOARDID_FAVOURITES: String = "favouritesNavigationSBID"
    
    // MARK: SEGUES
    static let SEGUE_CAMPAIGNDETAIL: String = "campaignDetail"
    static let SEGUE_STOREDETAIL: String = "storeDetail"
    static let SEGUE_MALLDETAIL: String = "mallDetail"
    
    
    // MARK: COLORS
    static let colorAppBackground: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    static let colorAppDarkerBackground: UIColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
    static let colorAppDarkBackground: UIColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
    
    static let colorAppMain: UIColor = UIColor(red: 252/255, green: 82/255, blue: 82/255, alpha: 1.0)
    static let colorAppLightMain: UIColor = UIColor(red: 255/255, green: 149/255, blue: 149/255, alpha: 1.0)
    static let colorAppVeryLightMain: UIColor = UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1.0)
    
    static let colorAppGray: UIColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    static let colorAppLightGray: UIColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
    static let colorAppVeryLightGray: UIColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    
    static let colorAppBlue: UIColor = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1.0) // Map pin colors
    static let colorAppLightBlue: UIColor = UIColor(red: 106/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let colorAppVeryBlue: UIColor = UIColor(red: 201/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    static let colorHeadingGray: UIColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    
    static let colorMainTitleGray: UIColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    static let colorTitleGray: UIColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    static let colorSubtitleGray: UIColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    
    static let colorPagingViewBackground: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    static let colorPagingViewCampaignDetailBackground: UIColor = UIColor(red: 180/255, green: 100/255, blue: 200/255, alpha: 0.7)
    static let colorPagingViewCampaignDetails: UIColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    
    static let colorPagingViewCampaignSubDetailBackground: UIColor = UIColor(red: 180/255, green: 100/255, blue: 100/255, alpha: 0.7)

    static let colorPagingViewCampaignCategoryBorder: UIColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    
    
     // MARK: FONTS
    
    static var fontHeading: UIFont? {
        return UIFont(name: "Futura", size: 26*UTILS.scaleFactor)
    }
    
    static var fontMainTitle: UIFont? {
        return UIFont(name: "Futura", size: 22*UTILS.scaleFactor)
        
    }
    
    static var fontTitle: UIFont? {
        return UIFont(name: "Futura", size: 19*UTILS.fontScaleFactor)
        
    }
    
    static var fontSubtitle: UIFont? {
        return UIFont(name: "Futura", size: 15*UTILS.fontScaleFactor)
        
    }
    
    static var fontPagingCampaignDetails: UIFont? {
        return UIFont(name: "Futura", size: 20*UTILS.fontScaleFactor)
        
    }
    
    static var fontPagingCampaignSubDetails: UIFont? {
        return UIFont(name: "Futura", size: 16*UTILS.fontScaleFactor)
    }
    
    
    static var fontFilterMenu: UIFont? {
        return UIFont(name: "Futura", size: 16)
    }
    
    static let DEFAULTIMAGE =  UIImage(named: "placeholder")
    
    static let DEFAULTSTOREIMAGE =  UIImage(named: "placeholder")
 
  }