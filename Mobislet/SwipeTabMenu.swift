//  CAPSPageMenu.swift
//
//  Niklas Fahl
//
//  Copyright (c) 2014 The Board of Trustees of The University of Alabama All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  Neither the name of the University nor the names of the contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import UIKit

@objc public protocol SwipeTabMenuDelegate {
    // MARK: - Delegate functions
    
    func swipeTabMenuDidSelectItem(menu: SwipeTabMenu, index: Int)

    // optional func willMoveToPage(controller: UIViewController, index: Int)
    optional func didMoveToPage(controller: UIViewController, index: Int)
}

class SwipeTabMenuItemView: UIView {
    // MARK: - Menu item view
    
    var titleLabel : UILabel?
    var menuItemSeparator : UIView?
    
    func setUpMenuItemView(menuItemWidth: CGFloat, menuScrollViewHeight: CGFloat, indicatorHeight: CGFloat, separatorPercentageHeight: CGFloat, separatorWidth: CGFloat, separatorRoundEdges: Bool, menuItemSeparatorColor: UIColor) {
        titleLabel = UILabel(frame: CGRectMake(0.0, 0.0, menuItemWidth, menuScrollViewHeight - indicatorHeight))
        
        menuItemSeparator = UIView(frame: CGRectMake(menuItemWidth - (separatorWidth / 2), floor(menuScrollViewHeight * ((1.0 - separatorPercentageHeight) / 2.0)), separatorWidth, floor(menuScrollViewHeight * separatorPercentageHeight)))
        menuItemSeparator!.backgroundColor = menuItemSeparatorColor
        
        if separatorRoundEdges {
            menuItemSeparator!.layer.cornerRadius = menuItemSeparator!.frame.width / 2
        }
        
        menuItemSeparator!.hidden = true
        self.addSubview(menuItemSeparator!)
        
        self.addSubview(titleLabel!)
    }
    
    func setTitleText(text: NSString) {
        if titleLabel != nil {
            titleLabel!.text = text as String
            titleLabel!.numberOfLines = 0
            titleLabel!.sizeToFit()
        }
    }
}

public enum SwipeTabMenuOption {
    case SelectionIndicatorHeight(CGFloat)
    case MenuItemSeparatorWidth(CGFloat)
    case ScrollMenuBackgroundColor(UIColor)
    case ViewBackgroundColor(UIColor)
    case BottomMenuHairlineColor(UIColor)
    case SelectionIndicatorColor(UIColor)
    case MenuItemSeparatorColor(UIColor)
    case MenuMargin(CGFloat)
    case MenuItemMargin(CGFloat)
    case MenuHeight(CGFloat)
    case SelectedMenuItemLabelColor(UIColor)
    case UnselectedMenuItemLabelColor(UIColor)
    case UseMenuLikeSegmentedControl(Bool)
    case MenuItemSeparatorRoundEdges(Bool)
    case MenuItemFont(UIFont)
    case MenuItemSeparatorPercentageHeight(CGFloat)
    case MenuItemWidth(CGFloat)
    case EnableHorizontalBounce(Bool)
    case AddBottomMenuHairline(Bool)
    case MenuItemWidthBasedOnTitleTextWidth(Bool)
    case TitleTextSizeBasedOnMenuItemWidth(Bool)
    case ScrollAnimationDurationOnMenuItemTap(Int)
    case CenterMenuItems(Bool)
    case HideTopMenuBar(Bool)
}

public class SwipeTabMenu: UIScrollView {
    
    // MARK: - Properties
    var menuArray : [(String, Int)] = []
    var menuItems : [SwipeTabMenuItemView] = []
    var menuItemWidths : [CGFloat] = []
    
    public var menuHeight : CGFloat = 30.0
    public var menuMargin : CGFloat = 15.0
    public var menuItemWidth : CGFloat = 111.0
    public var selectionIndicatorHeight : CGFloat = 3.0
    var totalMenuItemWidthIfDifferentWidths : CGFloat = 0.0
    public var scrollAnimationDurationOnMenuItemTap : Int = 500 // Millisecons
    var startingMenuMargin : CGFloat = 0.0
    var menuItemMargin : CGFloat = 0.0
    
    
    private var scaleParameter: CGFloat = 1.0 {
        didSet {
            
        }
    }
    
    var selectionIndicatorView : UIView = UIView()
    
    var currentPageIndex : Int = 0
    var lastPageIndex : Int = 0
    
    public var selectionIndicatorColor : UIColor = UIColor.blueColor()
    public var selectedMenuItemLabelColor : UIColor = UIColor.redColor()
    public var unselectedMenuItemLabelColor : UIColor = UIColor.lightGrayColor()
    public var scrollMenuBackgroundColor : UIColor = UIColor.yellowColor()
    public var viewBackgroundColor : UIColor = UIColor.blueColor()
    public var bottomMenuHairlineColor : UIColor = UIColor.blueColor()
    public var menuItemSeparatorColor : UIColor = UIColor.lightGrayColor()
    
    public var menuItemFont : UIFont = UIFont.systemFontOfSize(15.0)
    public var menuItemSeparatorPercentageHeight : CGFloat = 0.2
    public var menuItemSeparatorWidth : CGFloat = 0.5
    public var menuItemSeparatorRoundEdges : Bool = false
    
    public var addBottomMenuHairline : Bool = true
    public var menuItemWidthBasedOnTitleTextWidth : Bool = false
    public var titleTextSizeBasedOnMenuItemWidth : Bool = false
    public var useMenuLikeSegmentedControl : Bool = false
    public var centerMenuItems : Bool = false
    public var enableHorizontalBounce : Bool = true
    public var hideTopMenuBar : Bool = false
    
    var currentOrientationIsPortrait : Bool = true
    var pageIndexForOrientationChange : Int = 0
    var didLayoutSubviewsAfterRotation : Bool = false
    var didScrollAlready : Bool = false
    
    var lastControllerScrollViewContentOffset : CGFloat = 0.0
    
    var lastScrollDirection : CAPSPageMenuScrollDirection = .Other
    var startingPageForScroll : Int = 0
    var didTapMenuItemToScroll : Bool = false
    
    public weak var swipeMenuDelegate : SwipeTabMenuDelegate?
    
    var tapTimer : NSTimer?
    
    enum CAPSPageMenuScrollDirection : Int {
        case Left
        case Right
        case Other
    }
    
    // MARK: - View life cycle
    
    /**
    Initialize PageMenu with view controllers
    
    - parameter viewControllers: List of view controllers that must be subclasses of UIViewController
    - parameter frame: Frame for page menu view
    - parameter options: Dictionary holding any customization options user might want to set
    */
    
    
    /*
    public init( frame: CGRect, menuArray: [(String, Int)], options: [String: AnyObject]?) {
    super.init(frame: frame)
    
    self.menuArray = menuArray
    self.frame = frame
    }
    
    */
    
    init(frame: CGRect, menuArray:  [(String, Int)], pageMenuOptions: [SwipeTabMenuOption]?) {
        
        super.init(frame: frame)
        self.frame = frame
        
        configureView(menuArray: menuArray, pageMenuOptions: pageMenuOptions)
        
    }
    
    
    
    func configureView(menuArray menuArray:  [(String, Int)], pageMenuOptions: [SwipeTabMenuOption]?) {
        
        scaleParameter = UTILS.scaleFactor
        
        self.menuArray = menuArray
        configureSettings(pageMenuOptions)
        setUpUserInterface()
        //if self.subviews.count == 0 {
        configureUserInterface()
        // }
    }
    
    
    func configureSettings(pageMenuOptions: [SwipeTabMenuOption]?) {
        if let options = pageMenuOptions {
            for option in options {
                switch (option) {
                case let .SelectionIndicatorHeight(value):
                    selectionIndicatorHeight = value
                case let .MenuItemSeparatorWidth(value):
                    menuItemSeparatorWidth = value
                case let .ScrollMenuBackgroundColor(value):
                    scrollMenuBackgroundColor = value
                case let .ViewBackgroundColor(value):
                    viewBackgroundColor = value
                case let .BottomMenuHairlineColor(value):
                    bottomMenuHairlineColor = value
                case let .SelectionIndicatorColor(value):
                    selectionIndicatorColor = value
                case let .MenuItemSeparatorColor(value):
                    menuItemSeparatorColor = value
                case let .MenuMargin(value):
                    menuMargin = value
                case let .MenuItemMargin(value):
                    menuItemMargin = value
                case let .MenuHeight(value):
                    menuHeight = value
                case let .SelectedMenuItemLabelColor(value):
                    selectedMenuItemLabelColor = value
                case let .UnselectedMenuItemLabelColor(value):
                    unselectedMenuItemLabelColor = value
                case let .UseMenuLikeSegmentedControl(value):
                    useMenuLikeSegmentedControl = value
                case let .MenuItemSeparatorRoundEdges(value):
                    menuItemSeparatorRoundEdges = value
                case let .MenuItemFont(value):
                    menuItemFont = value
                case let .MenuItemSeparatorPercentageHeight(value):
                    menuItemSeparatorPercentageHeight = value
                case let .MenuItemWidth(value):
                    menuItemWidth = value
                case let .EnableHorizontalBounce(value):
                    enableHorizontalBounce = value
                case let .AddBottomMenuHairline(value):
                    addBottomMenuHairline = value
                case let .MenuItemWidthBasedOnTitleTextWidth(value):
                    menuItemWidthBasedOnTitleTextWidth = value
                case let .TitleTextSizeBasedOnMenuItemWidth(value):
                    titleTextSizeBasedOnMenuItemWidth = value
                case let .ScrollAnimationDurationOnMenuItemTap(value):
                    scrollAnimationDurationOnMenuItemTap = value
                case let .CenterMenuItems(value):
                    centerMenuItems = value
                case let .HideTopMenuBar(value):
                    hideTopMenuBar = value
                }
            }
            
            if hideTopMenuBar {
                addBottomMenuHairline = false
                menuHeight = 0.0
            }
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI Setup
    
    func setUpUserInterface() {
        
        // Set up controller scroll view
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alwaysBounceHorizontal = enableHorizontalBounce
        self.bounces = enableHorizontalBounce
        
        /*
        
        let controllerScrollView_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:|[controllerScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let controllerScrollView_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:|[controllerScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.view.addConstraints(controllerScrollView_constraint_H)
        self.view.addConstraints(controllerScrollView_constraint_V)
        */
        // Set up menu scroll view
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Add hairline to menu scroll view
        if addBottomMenuHairline {
            let menuBottomHairline : UIView = UIView()
            
            menuBottomHairline.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(menuBottomHairline)
            
            
            menuBottomHairline.backgroundColor = bottomMenuHairlineColor
        }
        
        // Disable scroll bars
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        // Set background color behind scroll views and for menu scroll view
        self.backgroundColor = viewBackgroundColor
        self.backgroundColor = scrollMenuBackgroundColor
    }
    
    func configureUserInterface() {
        // Add tap gesture recognizer to controller scroll view to recognize menu item selection
        let menuItemTapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleMenuItemTap:"))
        menuItemTapGestureRecognizer.numberOfTapsRequired = 1
        menuItemTapGestureRecognizer.numberOfTouchesRequired = 1
        //menuItemTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(menuItemTapGestureRecognizer)
        
        // When the user taps the status bar, the scroll view beneath the touch which is closest to the status bar will be scrolled to top,
        // but only if its `scrollsToTop` property is YES, its delegate does not return NO from `shouldScrollViewScrollToTop`, and it is not already at the top.
        // If more than one scroll view is found, none will be scrolled.
        // Disable scrollsToTop for menu and controller scroll views so that iOS finds scroll views within our pages on status bar tap gesture.
        self.scrollsToTop = false;
        
        // Configure menu scroll view
        if useMenuLikeSegmentedControl {
            self.scrollEnabled = false
            self.contentSize = CGSizeMake(self.frame.width, menuHeight)
            menuMargin = 0.0
        } else {
            self.contentSize = CGSizeMake((menuItemWidth + menuMargin) * CGFloat(menuArray.count) + menuMargin, menuHeight)
        }
        
        var index : CGFloat = 0.0
        
        for menu in menuArray {
            if index == 0.0 {
                // Add first two controllers to scrollview and as child view controller
                // addPageAtIndex(0)
            }
            
            // Set up menu item for menu scroll view
            var menuItemFrame : CGRect = CGRect()
            
            if useMenuLikeSegmentedControl {
                //**************************拡張*************************************
                if menuItemMargin > 0 {
                    let marginSum = menuItemMargin * CGFloat(menuArray.count + 1)
                    let menuItemWidth = (self.frame.width - marginSum) / CGFloat(menuArray.count)
                    menuItemFrame = CGRectMake(CGFloat(menuItemMargin * (index + 1)) + menuItemWidth * CGFloat(index), 0.0, CGFloat(self.frame.width) / CGFloat(menuArray.count), menuHeight)
                } else {
                    menuItemFrame = CGRectMake(self.frame.width / CGFloat(menuArray.count) * CGFloat(index), 0.0, CGFloat(self.frame.width) / CGFloat(menuArray.count), menuHeight)
                }
                //**************************拡張ここまで*************************************
            } else if menuItemWidthBasedOnTitleTextWidth {
                let controllerTitle : String? = "laga luga adad asdasd" // controller.title
                
                let titleText : String = controllerTitle != nil ? controllerTitle! : "Menu \(Int(index) + 1)"
                
                let itemWidthRect : CGRect = (titleText as NSString).boundingRectWithSize(CGSizeMake(1000, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:menuItemFont], context: nil)
                
                menuItemWidth = itemWidthRect.width
                
                menuItemFrame = CGRectMake(totalMenuItemWidthIfDifferentWidths + menuMargin + (menuMargin * index), 0.0, menuItemWidth, menuHeight)
                
                totalMenuItemWidthIfDifferentWidths += itemWidthRect.width
                menuItemWidths.append(itemWidthRect.width)
            } else {
                if centerMenuItems && index == 0.0  {
                    startingMenuMargin = ((self.frame.width - ((CGFloat(menuArray.count) * menuItemWidth) + (CGFloat(menuArray.count - 1) * menuMargin))) / 2.0) -  menuMargin
                    
                    if startingMenuMargin < 0.0 {
                        startingMenuMargin = 0.0
                    }
                    
                    menuItemFrame = CGRectMake(startingMenuMargin + menuMargin, 0.0, menuItemWidth, menuHeight)
                } else {
                    menuItemFrame = CGRectMake(menuItemWidth * index + menuMargin * (index + 1) + startingMenuMargin, 0.0, menuItemWidth, menuHeight)
                }
            }
            
            let menuItemView : SwipeTabMenuItemView = SwipeTabMenuItemView(frame: menuItemFrame)
            if useMenuLikeSegmentedControl {
                //**************************拡張*************************************
                if menuItemMargin > 0 {
                    let marginSum = menuItemMargin * CGFloat(menuArray.count + 1)
                    let menuItemWidth = (self.frame.width - marginSum) / CGFloat(menuArray.count)
                    menuItemView.setUpMenuItemView(menuItemWidth, menuScrollViewHeight: menuHeight, indicatorHeight: selectionIndicatorHeight, separatorPercentageHeight: menuItemSeparatorPercentageHeight, separatorWidth: menuItemSeparatorWidth, separatorRoundEdges: menuItemSeparatorRoundEdges, menuItemSeparatorColor: menuItemSeparatorColor)
                } else {
                    menuItemView.setUpMenuItemView(CGFloat(self.frame.width) / CGFloat(menuArray.count), menuScrollViewHeight: menuHeight, indicatorHeight: selectionIndicatorHeight, separatorPercentageHeight: menuItemSeparatorPercentageHeight, separatorWidth: menuItemSeparatorWidth, separatorRoundEdges: menuItemSeparatorRoundEdges, menuItemSeparatorColor: menuItemSeparatorColor)
                }
                //**************************拡張ここまで*************************************
            } else {
                menuItemView.setUpMenuItemView(menuItemWidth, menuScrollViewHeight: menuHeight, indicatorHeight: selectionIndicatorHeight, separatorPercentageHeight: menuItemSeparatorPercentageHeight, separatorWidth: menuItemSeparatorWidth, separatorRoundEdges: menuItemSeparatorRoundEdges, menuItemSeparatorColor: menuItemSeparatorColor)
            }
            
            // Configure menu item label font if font is set by user
            menuItemView.titleLabel!.font = menuItemFont
            
            menuItemView.titleLabel!.textAlignment = NSTextAlignment.Center
            menuItemView.titleLabel!.textColor = unselectedMenuItemLabelColor
            
            //**************************拡張*************************************
            menuItemView.titleLabel!.adjustsFontSizeToFitWidth = titleTextSizeBasedOnMenuItemWidth
            //**************************拡張ここまで*************************************
            
            // Set title depending on if controller has a title set
            menuItemView.titleLabel!.text = menu.0
            
            
            // Add separator between menu items when using as segmented control
            if useMenuLikeSegmentedControl {
                if Int(index) < menuArray.count - 1 {
                    menuItemView.menuItemSeparator!.hidden = false
                }
            }
            
            // Add menu item view to menu scroll view
            self.addSubview(menuItemView)
            menuItems.append(menuItemView)
            
            index++
        }
        
        // Set new content size for menu scroll view if needed
        if menuItemWidthBasedOnTitleTextWidth {
            self.contentSize = CGSizeMake((totalMenuItemWidthIfDifferentWidths + menuMargin) + CGFloat(menuArray.count) * menuMargin, menuHeight)
        }
        
        // Set selected color for title label of selected menu item
        if menuItems.count > 0 {
            if menuItems[currentPageIndex].titleLabel != nil {
                menuItems[currentPageIndex].titleLabel!.textColor = selectedMenuItemLabelColor
            }
        }
        
        // Configure selection indicator view
        var selectionIndicatorFrame : CGRect = CGRect()
        
        if useMenuLikeSegmentedControl {
            selectionIndicatorFrame = CGRectMake(0.0, menuHeight - selectionIndicatorHeight, self.frame.width / CGFloat(menuArray.count), selectionIndicatorHeight)
        } else if menuItemWidthBasedOnTitleTextWidth {
            selectionIndicatorFrame = CGRectMake(menuMargin, menuHeight - selectionIndicatorHeight, menuItemWidths[0], selectionIndicatorHeight)
        } else {
            if centerMenuItems  {
                selectionIndicatorFrame = CGRectMake(startingMenuMargin + menuMargin, menuHeight - selectionIndicatorHeight, menuItemWidth, selectionIndicatorHeight)
            } else {
                selectionIndicatorFrame = CGRectMake(menuMargin, menuHeight - selectionIndicatorHeight, menuItemWidth, selectionIndicatorHeight)
            }
        }
        
        selectionIndicatorView = UIView(frame: selectionIndicatorFrame)
        selectionIndicatorView.backgroundColor = selectionIndicatorColor
        self.addSubview(selectionIndicatorView)
        
        if menuItemWidthBasedOnTitleTextWidth && centerMenuItems {
            self.configureMenuItemWidthBasedOnTitleTextWidthAndCenterMenuItems()
            let leadingAndTrailingMargin = self.getMarginForMenuItemWidthBasedOnTitleTextWidthAndCenterMenuItems()
            selectionIndicatorView.frame = CGRectMake(leadingAndTrailingMargin, menuHeight - selectionIndicatorHeight, menuItemWidths[0], selectionIndicatorHeight)
        }
    }
    
    // Adjusts the menu item frames to size item width based on title text width and center all menu items in the center
    // if the menuItems all fit in the width of the view. Otherwise, it will adjust the frames so that the menu items
    // appear as if only menuItemWidthBasedOnTitleTextWidth is true.
    private func configureMenuItemWidthBasedOnTitleTextWidthAndCenterMenuItems() {
        // only center items if the combined width is less than the width of the entire view's bounds
        if self.contentSize.width < CGRectGetWidth(self.bounds) {
            // compute the margin required to center the menu items
            let leadingAndTrailingMargin = self.getMarginForMenuItemWidthBasedOnTitleTextWidthAndCenterMenuItems()
            
            // adjust the margin of each menu item to make them centered
            for (index, menuItem) in menuItems.enumerate() {
                let menutitle = menuArray[index].0
                
                let itemWidthRect = menutitle.boundingRectWithSize(CGSizeMake(1000, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:menuItemFont], context: nil)
                
                menuItemWidth = itemWidthRect.width
                
                var margin: CGFloat
                if index == 0 {
                    // the first menu item should use the calculated margin
                    margin = leadingAndTrailingMargin
                } else {
                    // the other menu items should use the menuMargin
                    let previousMenuItem = menuItems[index-1]
                    let previousX = CGRectGetMaxX(previousMenuItem.frame)
                    margin = previousX + menuMargin
                }
                
                menuItem.frame = CGRectMake(margin, 0.0, menuItemWidth, menuHeight)
            }
        } else {
            // the menuScrollView.contentSize.width exceeds the view's width, so layout the menu items normally (menuItemWidthBasedOnTitleTextWidth)
            for (index, menuItem) in menuItems.enumerate() {
                var menuItemX: CGFloat
                if index == 0 {
                    menuItemX = menuMargin
                } else {
                    menuItemX = CGRectGetMaxX(menuItems[index-1].frame) + menuMargin
                }
                
                menuItem.frame = CGRectMake(menuItemX, 0.0, CGRectGetWidth(menuItem.bounds), CGRectGetHeight(menuItem.bounds))
            }
        }
    }
    
    // Returns the size of the left and right margins that are neccessary to layout the menuItems in the center.
    private func getMarginForMenuItemWidthBasedOnTitleTextWidthAndCenterMenuItems() -> CGFloat {
        let menuItemsTotalWidth = self.contentSize.width - menuMargin * 2
        let leadingAndTrailingMargin = (CGRectGetWidth(self.bounds) - menuItemsTotalWidth) / 2
        
        return leadingAndTrailingMargin
    }
    
    
    // MARK: - Scroll view delegate
    public func scrollViewDidScroll(scrollView: UIScrollView) {
            // Move selection indicator view when swiping
            moveSelectionIndicator(currentPageIndex)
    }

    
    
    /*
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if scrollView.isEqual(controllerScrollView) {
    // Call didMoveToPage delegate function
    let currentController = controllerArray[currentPageIndex]
    delegate?.didMoveToPage?(currentController, index: currentPageIndex)
    
    // Remove all but current page after decelerating
    for key in pagesAddedDictionary.keys {
    if key != currentPageIndex {
    removePageAtIndex(key)
    }
    }
    
    didScrollAlready = false
    startingPageForScroll = currentPageIndex
    
    
    // Empty out pages in dictionary
    pagesAddedDictionary.removeAll(keepCapacity: false)
    }
    }
    
    */
    
    func scrollViewDidEndTapScrollingAnimation() {
        // Call didMoveToPage delegate function
        let currentController = menuArray[currentPageIndex]
        //delegate?.didMoveToPage?(currentController, index: currentPageIndex)
       
        startingPageForScroll = currentPageIndex
        didTapMenuItemToScroll = false
    }
    
    
    
    
    // MARK: - Handle Selection Indicator
    func moveSelectionIndicator(pageIndex: Int) {
        if pageIndex >= 0 && pageIndex < menuArray.count {
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                var selectionIndicatorWidth : CGFloat = self.selectionIndicatorView.frame.width
                var selectionIndicatorX : CGFloat = 0.0
                
                if self.useMenuLikeSegmentedControl {
                    selectionIndicatorX = CGFloat(pageIndex) * (self.frame.width / CGFloat(self.menuArray.count))
                    selectionIndicatorWidth = self.frame.width / CGFloat(self.menuArray.count)
                } else if self.menuItemWidthBasedOnTitleTextWidth {
                    selectionIndicatorWidth = self.menuItemWidths[pageIndex]
                    selectionIndicatorX = CGRectGetMinX(self.menuItems[pageIndex].frame)
                } else {
                    if self.centerMenuItems && pageIndex == 0 {
                        selectionIndicatorX = self.startingMenuMargin + self.menuMargin
                    } else {
                        selectionIndicatorX = self.menuItemWidth * CGFloat(pageIndex) + self.menuMargin * CGFloat(pageIndex + 1) + self.startingMenuMargin
                    }
                }
                
                self.selectionIndicatorView.frame = CGRectMake(selectionIndicatorX, self.selectionIndicatorView.frame.origin.y, selectionIndicatorWidth, self.selectionIndicatorView.frame.height)
                
                // Switch newly selected menu item title label to selected color and old one to unselected color
                if self.menuItems.count > 0 {
                    if self.menuItems[self.lastPageIndex].titleLabel != nil && self.menuItems[self.currentPageIndex].titleLabel != nil {
                        self.menuItems[self.lastPageIndex].titleLabel!.textColor = self.unselectedMenuItemLabelColor
                        self.menuItems[self.currentPageIndex].titleLabel!.textColor = self.selectedMenuItemLabelColor
                    }
                }
            })
        }    }
    
    
    // MARK: - Tap gesture recognizer selector
    func handleMenuItemTap(gestureRecognizer : UITapGestureRecognizer) {
        let tappedPoint : CGPoint = gestureRecognizer.locationInView(self)
        
        if tappedPoint.y < self.frame.height {

            // Calculate tapped page
            var itemIndex : Int = 0
            
            if useMenuLikeSegmentedControl {
                itemIndex = Int(tappedPoint.x / (self.frame.width / CGFloat(menuArray.count)))
            } else if menuItemWidthBasedOnTitleTextWidth {
                var menuItemLeftBound: CGFloat
                var menuItemRightBound: CGFloat
                
                if centerMenuItems {
                    menuItemLeftBound = CGRectGetMinX(menuItems[0].frame)
                    menuItemRightBound = CGRectGetMaxX(menuItems[menuItems.count-1].frame)
                    
                    if (tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound) {
                        for (index, _) in menuArray.enumerate() {
                            menuItemLeftBound = CGRectGetMinX(menuItems[index].frame)
                            menuItemRightBound = CGRectGetMaxX(menuItems[index].frame)
                            
                            if tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound {
                                itemIndex = index
                                break
                            }
                        }
                    }
                } else {
                    // Base case being first item
                    menuItemLeftBound = 0.0
                    menuItemRightBound = menuItemWidths[0] + menuMargin + (menuMargin / 2)
                    
                    if !(tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound) {
                        for i in 1...menuArray.count - 1 {
                            menuItemLeftBound = menuItemRightBound + 1.0
                            menuItemRightBound = menuItemLeftBound + menuItemWidths[i] + menuMargin
                            
                            if tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound {
                                itemIndex = i
                                break
                            }
                        }
                    }
                }
            } else {
                let rawItemIndex : CGFloat = ((tappedPoint.x - startingMenuMargin) - menuMargin / 2) / (menuMargin + menuItemWidth)
                
                // Prevent moving to first item when tapping left to first item
                if rawItemIndex < 0 {
                    itemIndex = -1
                } else {
                    itemIndex = Int(rawItemIndex)
                }
            }
            
            
            if itemIndex >= 0 && itemIndex < menuArray.count {
                // Update page if changed
                if itemIndex != currentPageIndex {
                    startingPageForScroll = itemIndex
                    lastPageIndex = currentPageIndex
                    currentPageIndex = itemIndex
                    didTapMenuItemToScroll = true
                    
                    
                    moveSelectionIndicator(itemIndex)
                    scrollMenuToSelectedItem(itemIndex)
                    self.swipeMenuDelegate?.swipeTabMenuDidSelectItem(self, index: itemIndex)
                    
                }
                
                
                
               
                if tapTimer != nil {
                    tapTimer!.invalidate()
                }
                
                let timerInterval : NSTimeInterval = Double(scrollAnimationDurationOnMenuItemTap) * 0.001
                tapTimer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: "scrollViewDidEndTapScrollingAnimation", userInfo: nil, repeats: false)
            }
        }
    }
   
    func scrollMenuToSelectedItem(itemIndex: Int) {

        var offset: CGFloat = 0.0
        
        let ratio = CGFloat(itemIndex) / CGFloat(menuItems.count-1) // (self.frame.width) / self.contentSize.width
        
        if self.contentSize.width > self.frame.width {
            offset = (self.contentSize.width - self.frame.width) * ratio
        }
 
    
        // Move controller scroll view when tapping menu item
        let duration : Double = Double(scrollAnimationDurationOnMenuItemTap) / Double(1000)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            // let
            self.setContentOffset(CGPoint(x: offset, y: self.contentOffset.y), animated: false)
        })
 
        
     }
    
    // MARK: - Move to page index
    
    /**
    Move to page at index
    
    - parameter index: Index of the page to move to
    */
    public func moveToPage(index: Int) {
        if index >= 0 && index < menuArray.count {
            // Update page if changed
            if index != currentPageIndex {
                startingPageForScroll = index
                lastPageIndex = currentPageIndex
                currentPageIndex = index
                didTapMenuItemToScroll = true
                
                // Add pages in between current and tapped page if necessary
                let smallerIndex : Int = lastPageIndex < currentPageIndex ? lastPageIndex : currentPageIndex
                let largerIndex : Int = lastPageIndex > currentPageIndex ? lastPageIndex : currentPageIndex
               
            }
            
            // Move controller scroll view when tapping menu item
            let duration : Double = Double(scrollAnimationDurationOnMenuItemTap) / Double(1000)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                //let xOffset : CGFloat = CGFloat(index) * self.controllerScrollView.frame.width
                // self.controllerScrollView.setContentOffset(CGPoint(x: xOffset, y: self.controllerScrollView.contentOffset.y), animated: false)
            })
        }
    }
}
