//
//  FeedCell.swift
//  Firebase Showcase
//
//  Created by Ahmet KÖRÜK on 29/01/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit
import Alamofire

class StoreCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var store: Store!
    
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeButton.addGestureRecognizer(tap)
        likeButton.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        storeImageView.layer.cornerRadius = 5.0
        storeImageView.clipsToBounds = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(aStore: Store) {
        
        self.store = aStore
        
        if self.store.userLiked {
            self.likeButton?.setImage(UIImage(named: "like_active"), forState: .Normal)
        } else {
            self.likeButton?.setImage(UIImage(named: "like_passive"), forState: .Normal)
        }
        
        self.nameLabel.text = self.store.name
        self.locationLabel.text = self.store.locationInMall
        
        if self.store.brand?.categories.count > 0 {
            self.categoryLabel.text = "\(self.store.brand!.categories[0].name)"
        } else {
            self.categoryLabel.text = ""
        }
  
        self.storeImageView.image = CONSTANTS.DEFAULTSTOREIMAGE

        if let imageNamed = self.store.brand?.imageNamed {
            
            if let image = DataService.imageCache.objectForKey(imageNamed) as? UIImage {
                // image = aImg
                self.storeImageView.image = image
                
            } else {
                request = Alamofire.request(.GET, imageNamed)
                    .responseImage { response in
                        
                        if let _ = response.result.error {
                            print("Error downloading image")
                            self.storeImageView.image = CONSTANTS.DEFAULTSTOREIMAGE
                            
                        } else if let image = response.result.value {
                            
                            DataService.imageCache.setObject(image, forKey: imageNamed)
                            self.storeImageView.image = image
                        }
                }
            }
            
        }        
     }
    
    func likeTapped(tap: UIGestureRecognizer) {
        
        print("This is hit!")
        
        store.setUserLike(!store.userLiked)
        
        if self.store.userLiked {
            self.likeButton?.setImage(UIImage(named: "like_active"), forState: .Normal)
        } else {
            self.likeButton?.setImage(UIImage(named: "like_passive"), forState: .Normal)
        }
        
        
    }
    
}
