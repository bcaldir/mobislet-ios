//
//  RoundedImageView.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 30/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class RoundedImageView: UIView {

    var imageView: UIImageView?
    var offset: CGFloat = 12.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var cornerRadius: CGFloat = 3.0 {
        didSet {
            // self.imageView?.layer.cornerRadius = self.cornerRadius
            self.layer.cornerRadius = self.cornerRadius
            }
    }
    
    var borderWidth: CGFloat = 3.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
   
    override func drawRect(rect: CGRect) {
        
        imageView = UIImageView(frame: CGRectMake(self.offset, self.offset, rect.width - 2*self.offset, rect.height - 2*self.offset))
        self.addSubview(self.imageView!)
        // imageView?.image = UIImage(named: "installment")
        
        
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = borderWidth

        imageView?.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
   
        
        imageView?.layer.borderColor = CONSTANTS.colorPagingViewCampaignCategoryBorder.CGColor
        imageView?.contentMode = .Center
        imageView?.contentMode = .ScaleAspectFit
        
        // self.setImageNamed("installment")
       
    }
    
    func setImageNamed(imageNamed: String) {
        
        // print("imageNamed: \(imageNamed)")
        self.imageView?.image = UIImage(named: imageNamed)
    }

}

