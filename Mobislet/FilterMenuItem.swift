//
//  FilterMenuItem.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 15/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

protocol FilterMenuItemDelegate {
    func filterMenuItemSelected(filterMenuItem: FilterMenuItem, withCategory: Int)
}

class FilterMenuItem: UIView, UIGestureRecognizerDelegate {

    
    var delegate: FilterMenuItemDelegate?
    
    // MARK: - Menu item view
    private var titleLabel : UILabel!
    private var selectorView : UIView!
    
    var selected : Bool = false {
        didSet {
            self.selectorView.hidden = !selected
        }
    }
    
    var category: Int = -1
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    func configure(itemWidth: CGFloat, itemHeight: CGFloat, horizontalMargin: CGFloat, selectorHeight: CGFloat) {
        
        titleLabel = UILabel(frame: CGRectMake(horizontalMargin, 0.0, itemWidth-2*horizontalMargin, itemHeight - selectorHeight))
        titleLabel.textAlignment = .Center
        titleLabel.font = CONSTANTS.fontFilterMenu
        titleLabel.textColor = CONSTANTS.colorAppGray
        
        selectorView = UIView(frame: CGRectMake(horizontalMargin, itemHeight-selectorHeight, itemWidth-2*horizontalMargin, selectorHeight))
        selectorView.backgroundColor = CONSTANTS.colorAppMain
        
        self.addSubview(titleLabel)
        
        self.addSubview(selectorView)
        selectorView.hidden = true
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleFilterTap:")
        self.addGestureRecognizer(tap)
        tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
        
    }
    
    func setTitle(text: NSString) {
            titleLabel!.text = text as String
            titleLabel!.numberOfLines = 0
    }
    
    func handleFilterTap(gesture: UITapGestureRecognizer) {
        
        self.selected = true
        
        if let item = gesture.view as? FilterMenuItem {
            print("Category: \(item.category)")

                delegate?.filterMenuItemSelected(self, withCategory: category)
        }
        
    }

    
}
