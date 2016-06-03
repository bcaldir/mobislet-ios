//
//  MAGPagedReusableScrollView.swift
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

@objc public protocol PagedReusableScrollViewDataSource {
    
    func scrollView(scrollView: PagedReusableScrollView, viewIndex index: Int) -> ScrollViewPageProvider
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int
    
    optional func scrollView(scrollView scrollView: PagedReusableScrollView, selectedIndex index:Int)
    
    optional func scrollView(scrollView scrollView: PagedReusableScrollView, willShowView view:ScrollViewPageProvider)
    optional func scrollView(scrollView scrollView: PagedReusableScrollView, willHideView view:ScrollViewPageProvider)
    optional func scrollView(scrollView scrollView: PagedReusableScrollView, didShowView view:ScrollViewPageProvider)
    optional func scrollView(scrollView scrollView: PagedReusableScrollView, didHideView view:ScrollViewPageProvider)
    
}


public class PagedReusableScrollView: PagedScrollView {
    
    @IBOutlet public weak var dataSource:PagedReusableScrollViewDataSource! {
        didSet {
            reload()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reload()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reload()
    }
    
    public func reload() {
        clearAllViews()
        if let ds = dataSource {
            viewsCount = ds.numberOfViews(forScrollView: self)
            resizeContent()
            reloadVisibleViews()
        }
        setNeedsLayout()
    }

    public var visibleIndexes:[Int] {
        if let viewsCount = viewsCount {
            var result = [Int]()
            //Add previous page
            if pageNumber > 0 && (pageNumber-1) < viewsCount {
                result.append(pageNumber-1)
            }
            //Add curent page
            if pageNumber < viewsCount {
                result.append(pageNumber)
            }
            //Add next page
            if (pageNumber+1) < viewsCount {
                result.append(pageNumber+1)
            }
            return result
        } else {
            return []
        }
    }
    
    override public func viewsOnScreen() -> [UIView] {
        return visibleIndexes.sort{ $0 > $1 }.map{ self.activeViews[$0]! }
    }

    
    public func dequeueReusableView(tag tag:Int) -> ScrollViewPageProvider? {
        for (index, view) in dirtyViews.enumerate() {
            if view.tag == tag {
                dirtyViews.removeAtIndex(index)
                // view.prepareForReuse?()
                return view
            }
        }
        return nil
    }
    
    public func dequeueReusableView(viewClass viewClass:AnyClass) -> ScrollViewPageProvider? {
        for (index, view) in dirtyViews.enumerate() {
            if view.isKindOfClass(viewClass) {
                dirtyViews.removeAtIndex(index)
                // view.prepareForReuse?()
                return view
            }
        }
        return nil
    }

  
    override public func didMoveToSuperview() {
        super.didMoveToSuperview();
        if superview != nil {
            reload()
        }
    }
    
    //MARK: private data
    private(set) public var activeViews:[Int:ScrollViewPageProvider] = [:]
    private var dirtyViews:[ScrollViewPageProvider] = []
    private var viewsCount:Int?
    private var itemSize:CGSize = CGSizeZero
    
    private func reloadVisibleViews() {
        let visibleIdx  = visibleIndexes.sort{ $0 > $1 }
        let activeIdx = activeViews.keys.sort{ $0 > $1 }
        if visibleIdx != activeIdx {
            //get views to make them dirty
            _ = activeIdx.substract(visibleIdx).map { self.makeViewDirty(index:$0) }
            // add new views
            _ = visibleIdx.substract(activeIdx).map { self.addView(index:$0) }
            setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        if itemSize != UIEdgeInsetsInsetRect(frame, contentInset).size {
            reload()
            return
        }
        reloadVisibleViews()
        super.layoutSubviews()
    }

    
    private func makeViewDirty(index index:Int) {
        if let view = activeViews[index] {
            dataSource?.scrollView?(scrollView: self, willHideView: view)
            view.removeFromSuperview()
            dataSource?.scrollView?(scrollView: self, didHideView: view)
            view.layer.transform = CATransform3DIdentity
            dirtyViews.append(view)
            activeViews.removeValueForKey(index)
        }
    }
    
    private func addView(index index:Int) {

        if let view = dataSource?.scrollView(self, viewIndex: index) {
            view.removeFromSuperview()
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = CGRectGetWidth(frameI)
            let height = CGRectGetHeight(frameI)
            let x:CGFloat = CGFloat(index) * width
            view.frame = CGRectMake(x, 0, width, height)
            dataSource?.scrollView?(scrollView: self, willShowView: view)
            addSubview(view)
            dataSource?.scrollView?(scrollView: self, didShowView: view)
            view.layer.transform = CATransform3DIdentity
            activeViews[index] = view
        }
    }
    
    private func clearAllViews () {
        for (_ , value) in activeViews {
            dataSource?.scrollView?(scrollView: self, willHideView: value)
            value.removeFromSuperview()
            dataSource?.scrollView?(scrollView: self, didHideView: value)
        }
        activeViews = [:]
        dirtyViews = []
        viewsCount = nil
        itemSize = CGSizeZero
        resizeContent()
    }

    private func resizeContent() {
        if let viewsCount = viewsCount {
            let frameI = UIEdgeInsetsInsetRect(frame, contentInset)
            let width = CGRectGetWidth(frameI)
            let height = CGRectGetHeight(frameI)
            let x:CGFloat = CGFloat(viewsCount) * width
            contentSize = CGSizeMake(x, height)
            itemSize = frameI.size
        } else {
            contentSize = CGSizeZero
            itemSize = CGSizeZero
        }
        contentOffset = CGPointZero
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha = 0.5
   
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.alpha = 1.0
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha = 1.0
        
        let index: Int = (Int)(self.contentOffset.x / self.frame.size.width)
        
        self.dataSource?.scrollView?(scrollView: self, selectedIndex:index)

    }


}



extension Array {
    
    func substract <T: Equatable> (values: [T]...) -> [T] {
        var result = [T]()
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //if our internal element is present in substract array
                    //exclude it from result
                    if value.contains(element) {
                        continue elements
                    }
                }
                
                //  element it's only in self, so return it
                result.append(element)
            }
        }
        return result
    }
    
}
