//
//  DataProvider.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 17/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

public class ScrollViewPageProvider: UIView {
    
    private var data: Mobitem!
    var requests = [Request]()
    
    
    var mainImageView: UIImageView? {
        didSet {
            mainImageView!.removeFromSuperview()
            self.addSubview(mainImageView!)
        }
    }
    
    var mainTitleLabel: UILabel? {
        didSet {
            mainTitleLabel!.removeFromSuperview()
            self.addSubview(mainTitleLabel!)
        }
    }
    
    var titleLabel: UILabel? {
        didSet {
            titleLabel!.removeFromSuperview()
            self.addSubview(titleLabel!)
        }
    }
    
    var subTitleLabel: UILabel? {
        didSet {
            subTitleLabel!.removeFromSuperview()
            self.addSubview(subTitleLabel!)
        }
    }
    
    var itemDetailsBackgroundView: UIView? {
        didSet {
            itemDetailsBackgroundView!.removeFromSuperview()
            self.addSubview(itemDetailsBackgroundView!)
        }
    }
    
    var itemDetailsLabel: UILabel?
    
    var itemSubDetailsLabel: UILabel? {
        didSet {
            itemSubDetailsLabel!.removeFromSuperview()
            self.addSubview(itemSubDetailsLabel!)
        }
    }
    
    
    var roundedImageView: RoundedImageView? {
        didSet {
            roundedImageView!.removeFromSuperview()
            self.addSubview(roundedImageView!)
        }
    }
    
    var likeButton: UIButton? {
        didSet {
            likeButton!.removeFromSuperview()
            self.addSubview(likeButton!)
            
            // likeButton?.hidden = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ScrollViewPageProvider.likeTapped(_:)))
            tap.numberOfTapsRequired = 1
            likeButton?.addGestureRecognizer(tap)
            likeButton?.userInteractionEnabled = true
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getDescription() -> String {
        return "\(data.mobitemType) - \(data.userLiked)"
    }
    
    func configureView(dat: Mobitem) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            
            
            self.data = dat
            
            let item = self.data
            
            switch item.mobitemType {
            case .Default:
                self.mainImageView?.image = UIImage(named:"photo\(2).jpg")
                self.mainTitleLabel?.text = "Hello People - \(3)"
                
            case .Campaign:
                
                let camp = item as! Campaign
                self.mainImageView?.setImageFromScrollViewPageProvider(self, imageView: self.mainImageView, imageName: camp.imageNamed)
                
                
                self.mainTitleLabel?.text = camp.store?.name
                self.itemDetailsLabel?.text = camp.name
                
                self.roundedImageView?.backgroundColor = UIColor.whiteColor()
                if let categoryDesc = camp.categoryDescription {
                    self.roundedImageView?.setImageNamed(categoryDesc)

                }
            
                self.itemSubDetailsLabel?.hidden = false

                if camp.isPopular {
                    self.itemSubDetailsLabel?.text = STATICS.TEXT_MOBITEM_POPULAR
                } else if camp.isNew {
                    self.itemSubDetailsLabel?.text = STATICS.TEXT_MOBITEM_NEW
                } else {
                    self.itemSubDetailsLabel?.hidden = true
                }
                
                self.itemSubDetailsLabel?.sizeToFit()
                
                if camp.userLiked {
                    self.likeButton?.setImage(UIImage(named: "like_active"), forState: .Normal)
                } else {
                    self.likeButton?.setImage(UIImage(named: "like_passive"), forState: .Normal)
                }
                
            case .Store:
                
                let store = item as! Store
                
                self.mainImageView?.setImageFromScrollViewPageProvider(self, imageView: self.mainImageView, imageName: store.brand?.imageNamed)
                
                self.titleLabel?.text = store.name
                
                if store.campaignCount > 0 {
                    self.subTitleLabel?.text = "\(store.campaignCount) aktif kampanya"
                } else {
                    self.subTitleLabel?.text = ""
                }
                
                
                if store.isPopular {
                    self.itemSubDetailsLabel?.text = STATICS.TEXT_MOBITEM_POPULAR
                } else if store.isNew {
                    self.itemSubDetailsLabel?.text = STATICS.TEXT_MOBITEM_NEW
                } else {
                    self.itemSubDetailsLabel?.hidden = true
                }
                

                self.itemSubDetailsLabel?.sizeToFit()
                
                if store.userLiked {
                    self.likeButton?.setImage(UIImage(named: "like_active"), forState: .Normal)
                } else {
                    self.likeButton?.setImage(UIImage(named: "like_passive"), forState: .Normal)
                }
                
            case .Mall:
                
                let mall = item as! Mall
                
                self.mainImageView?.setImageFromScrollViewPageProvider(self, imageView: self.mainImageView, imageName: mall.imageNamed)
                
                self.mainTitleLabel?.text = mall.name
                
                if mall.userLiked {
                    self.likeButton?.setImage(UIImage(named: "like_active"), forState: .Normal)
                } else {
                    self.likeButton?.setImage(UIImage(named: "like_passive"), forState: .Normal)
                }
                
            }
        })
        
    }
    
    func likeTapped(sender: UIButton!) {
        
        self.data.setUserLike(!self.data.userLiked)
        
        if self.data.userLiked {
            self.likeButton?.setImage(UIImage(named: "like_active"), forState: .Normal)
        } else {
            self.likeButton?.setImage(UIImage(named: "like_passive"), forState: .Normal)
        }
    }
    
    func cancelRequests() {
        while self.requests.count > 0 {
            let request = self.requests.removeFirst()
            request.cancel()
        }
    }
    
    /*
    func getImageFromCache(imageNamed: String?) -> UIImage? {
    
    var image: UIImage?
    
    if let imgName = imageNamed {
    
    
    if let aImg = DataService.imageCache.objectForKey(imgName) as? UIImage {
    image = aImg
    } else {
    
    let request = Alamofire.request(Alamofire.Method.GET, imgName).validate(contentType: ["image/*"]).response(completionHandler: { req, res, data, err in
    
    if err != nil {
    print("Error in downloading image")
    } else {
    let image = UIImage(data: data!)
    DataService.imageCache.setObject(image!, forKey: imgName)
    }
    })
    self.requests.append(request)
    }
    }
    
    return image
    }
    */
    */
    
}


extension UIImageView {
    
    func setImageFromScrollViewPageProvider(pageProvider: ScrollViewPageProvider, imageView: UIImageView?, imageName:  String?) {
        
        // var image: UIImage?
        
        if let imageNamed = imageName {
            
            if let image = DataService.imageCache.objectForKey(imageNamed) as? UIImage {
                // image = aImg
                imageView?.image = image
            } else {
                
                let request = Alamofire.request(.GET, imageNamed)
                    .responseImage { response in
                        
                        if let _ = response.result.error {
                            print("Error downloading image")
                            imageView?.image = CONSTANTS.DEFAULTIMAGE

                        } else if let image = response.result.value {
                            
                            DataService.imageCache.setObject(image, forKey: imageNamed)
                            imageView?.image = image
                        }
                        
                        
                }
                
                pageProvider.requests.append(request)
            }
        }
        
        
    }
}




















