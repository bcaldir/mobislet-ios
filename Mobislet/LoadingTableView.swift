//
//  LoadingTableView.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 09/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class LoadingTableView: UITableView {
    
    var loadingView : MAActivityIndicatorView?
    private var loadingViewHeight:CGFloat = 30.0
    
    // Check here for every variables
    private var scaleParameter: CGFloat = 1.0 {
        didSet {
            loadingViewHeight *= scaleParameter
        }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
    }
    
    func showLoadingIndicator(frame: CGRect) {
        
        // let width = self.frame.width
        // let height = self.bounds.height
        
        self.loadingView = MAActivityIndicatorView(frame: frame)
        self.loadingView?.style = IndicatorViewType.Normal
        // self.loadingView?.center = self.center
 
        self.addSubview(self.loadingView!)
        
        self.loadingView?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        self.loadingView?.removeFromSuperview()
    }
}














