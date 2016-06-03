//
//  MaterialButton.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 18/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {
    
    convenience init(frame: CGRect, imageNamed: String) {
        self.init(frame: frame)
        
        setImage(UIImage(named: imageNamed), forState: UIControlState.Normal)
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: 200/255, green:  200/255, blue:  200/255, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
