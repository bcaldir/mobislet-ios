//
//  ViewController.swift
//  PageMenuDemoStoryboard
//
//  Created by Niklas Fahl on 12/19/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit

class MallDetailViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, FilterMenuItemDelegate {
    
    var mall: Mall!
    
    var filteredStores = [Store]()
    
    var searchController: UISearchController!
    
    var setup = false
    var inSearchMode = false
    var inFilterMode = false
    
    private var navigationBarItemHeight:CGFloat = 30
    
    var filterMenuItemWidth: CGFloat = 100.0
    var filterMenuHeight: CGFloat = 40.0
    
    var filterMenuHorizontalMargin: CGFloat = 10.0
    var filterMenuSelectorHeight: CGFloat = 3.0
    
    var filterMenuItems = [FilterMenuItem]()
    let filterMenuItemDefaultValue = ("Tümü", -1)
    
    private var menuScaleFactor: CGFloat = 1.0 {
        didSet {
            
        }
    }
    
    @IBOutlet weak var filterMenu : UIScrollView!
    @IBOutlet weak var storesTableview: LoadingTableView!
    //@IBOutlet weak var storesTableview: UITableView!
    
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuScaleFactor = UTILS.menuScaleFactor
        
        setupNavigationBar()
        
        let menuArray = [filterMenuItemDefaultValue]
        setupFilterMenu(menuArray)
        
        setupTableView()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
        self.navigationController?.navigationBar.backgroundColor = CONSTANTS.colorAppLightMain
        
    }
    
    
    // MARK: - Actions and Helpers
    func backButtonTapped() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupNavigationBar() {
        
        // self.navigationController?.navigationBar.hidden  = false
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        self.searchController.searchBar.placeholder = self.mall?.name
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        
        self.searchController.searchBar.delegate = self
        
        self.searchController.searchBar.setValue("İptal", forKey: "_cancelButtonText")
        
        // [searchBar setValue:@"customString" forKey:@"_cancelButtonText"];
        
        /*
         let searchBarImg: UIImage = UIImage(named: "at_symbol_for_search_bar")!
         self.searchController.searchBar.setImage(searchBarImg, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
         */
        
        // searchController.searchBar.delegate = self
        
        
        /*
         self.searchBar = UISearchBar()
         
         self.searchBar.sizeToFit()
         
         self.searchBar.placeholder = self.mall?.name
         self.navigationItem.titleView = self.searchBar
         
         
         self.searchBar.delegate = self
         
         */
        
        // Search bar placeholder and text color
        /*
         
         let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as? UITextField
         textFieldInsideSearchBar?.textColor = CONSTANTS.colorAppBlue
         
         let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
         // textFieldInsideSearchBarLabel?.textColor = UIColor.redColor()
         
         let searchBarImg: UIImage = UIImage(named: "search")!
         self.searchBar.setImage(searchBarImg, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
         */
        
        //create a new button
        let backButton: UIButton = UIButton(type: UIButtonType.Custom)
        //set image for button
        backButton.setImage(UIImage(named: "nav_back"), forState: UIControlState.Normal)
        //add function for button
        backButton.addTarget(self, action: "backButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        backButton.frame = CGRectMake(0, 0, navigationBarItemHeight, navigationBarItemHeight)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    
    
    func setupFilterMenu(menuArray: [(String, Int)]) {
        
        
        for itemAlreadyAdded in filterMenuItems {
            itemAlreadyAdded.removeFromSuperview()
        }
        
        self.filterMenu.backgroundColor = CONSTANTS.colorAppBackground
        
        filterMenuItems = []
        
        filterMenu.delegate = self
        
        self.filterMenu.contentSize = CGSize(width: 0, height: self.filterMenu.frame.height)
        
        for i in 0..<menuArray.count {
            
            
            //let expectedLabelSize: CGSize = menuArray[i].0.sizeWithFont(CONSTANTS.fontFilterMenu, constrainedToSize: 20, lineBreakMode: NSLineBreakMode.ByTruncatingHead)
            
            let text = menuArray[i].0
            
            
            var itemPosX:CGFloat = 0.0
            for j in 0..<i {
                itemPosX += filterMenuItems[j].frame.width
            }
            
            let itemPosY:CGFloat = 0.0
            
            var itemWidth:CGFloat = self.filterMenuItemWidth
            
            if let font = CONSTANTS.fontFilterMenu {
                itemWidth = text.sizeWithAttributes([NSFontAttributeName:font]).width + 2*self.filterMenuHorizontalMargin
            }
            
            let itemHeight:CGFloat = self.filterMenuHeight
            
            /*
             let menuLabel = UILabel(frame: CGRectMake(posX + self.filterMenuHorizontalMargin, posY, self.filterMenuWidth - 2*self.filterMenuHorizontalMargin, self.filterMenuHeight))
             menuLabel.text = menuArray[i].0
             
             menuLabel.userInteractionEnabled = true
             menuLabel.tag = menuArray[i].1
             */
            
            let menuItem = FilterMenuItem(frame: CGRectMake(itemPosX, itemPosY, itemWidth, self.filterMenuHeight))
            
            menuItem.configure(itemWidth, itemHeight: itemHeight, horizontalMargin: self.filterMenuHorizontalMargin,selectorHeight: filterMenuSelectorHeight)
            // Adding tap gesture
            menuItem.delegate = self
            menuItem.setTitle(menuArray[i].0)
            menuItem.category = menuArray[i].1
            
            if i == 0 {
                menuItem.selected = true
            }
            
            self.filterMenu.addSubview(menuItem)
            self.filterMenuItems.append(menuItem)
            
            self.filterMenu.contentSize.width += itemWidth
        }
        
        self.filterMenu.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func filterMenuScrollToSelectedItem(itemIndex: Int) {
        
        var offset: CGFloat = 0.0
        
        offset = self.filterMenuItems[itemIndex].frame.origin.x + self.filterMenuItems[itemIndex].frame.width/2 - self.view.frame.width/2
        
        
        /*
         for i in 0..<itemIndex {
         offset += self.filterMenuItems[i].frame.width
         if (offset + self.view.frame.width) > self.filterMenu.contentSize.width {
         offset -= self.filterMenuItems[i].frame.width
         }
         }
         */
        
        /*
         let ratio = CGFloat(itemIndex) / CGFloat(filterMenuItems.count-1) // (self.frame.width) / self.contentSize.width
         
         if self.filterMenu.contentSize.width > self.filterMenu.frame.width {
         offset = (self.filterMenu.contentSize.width - self.filterMenu.frame.width) * ratio
         }
         */
        
        
        
        
        // offset = self.filterMenuItems[itemIndex].frame.origin.x + self.filterMenuItems[itemIndex].frame.width/2 - self.view.frame.width/2
        
        /*
         if (self.filterMenuItems[itemIndex].frame.origin.x + self.filterMenuItems[itemIndex].frame.width) > offset {
         offset = self.filterMenuItems[itemIndex].frame.origin.x + self.filterMenuItems[itemIndex].frame.width/2 - self.view.frame.width/2
         } else {
         offset = 0.0
         }
         
         */
        
        
        // Move controller scroll view when tapping menu item
        let duration : Double = 0.5
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            // let
            self.filterMenu.setContentOffset(CGPoint(x: offset, y: self.filterMenu.contentOffset.y), animated: false)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //print("X:\(scrollView.contentOffset.x)")
        //print("Y:\(scrollView.contentOffset.y)")
        if scrollView.tag == 1 {
            scrollView.contentOffset.y = 0
        }
    }
    
    func filterMenuItemSelected(filterMenuItem: FilterMenuItem, withCategory: Int) {
        for i in 0..<filterMenuItems.count {
            let item = filterMenuItems[i]
            
            if item.category == withCategory {
                item.selected = true
                filterTableByCategory(withCategory)
                filterMenuScrollToSelectedItem(i)
            } else {
                item.selected = false
            }
        }
    }
    
    
    func filterTableByCategory(category: Int) {
        
        self.inSearchMode = false
        self.inFilterMode = false
        
        if category == self.filterMenuItemDefaultValue.1 {
            
        } else {
            self.inFilterMode = true
            
            let allStores: [Store] = self.mall.stores
            
            self.filteredStores =  allStores.filter({ (theStore: Store) -> Bool in
                
                if let brand = theStore.brand {
                    if brand.categories.count > 0 {
                        for cat in brand.categories {
                            if cat.code == category {
                                return true
                            }
                        }
                    }
                }
                
                return false
            })
        }
        
        self.storesTableview.reloadData()
    }
    
    func setupTableView() {
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        self.storesTableview.keyboardDismissMode = .OnDrag
        
        self.storesTableview.delegate = self
        self.storesTableview.dataSource = self
        self.storesTableview.showLoadingIndicator(CGRectMake(0, 0, width, height))
        //self.filterMenu.hidden = true
        
        self.mall.downloadStores { () -> () in
            print("Store count: " + "\(self.mall.stores.count)")
            self.storesTableview.reloadData()
            self.storesTableview.hideLoadingIndicator()
            // self.filterMenu.hidden = false
            self.reloadFilterMenu()
        }
    }
    
    func reloadFilterMenu() {
        var filterMenuArray = [(String, Int)]()
        
        for store in mall.stores {
            
            if let brand = store.brand {
                if brand.categories.count > 0 {
                    var alreadyAdded = false
                    for filterMenu in filterMenuArray {
                        if filterMenu.1 == brand.categories[0].code {
                            alreadyAdded = true
                        }
                    }
                    if !alreadyAdded {
                        filterMenuArray.append((brand.categories[0].name, brand.categories[0].code))
                    }
                }
            }
        }
        
        filterMenuArray = filterMenuArray.sort({ (menu1, menu2) -> Bool in
            menu1.0 < menu2.0
        })
        
        filterMenuArray.insert(self.filterMenuItemDefaultValue, atIndex: 0)
        
        self.setupFilterMenu(filterMenuArray)
    }
    
    // MARK: - Search Result Update Results Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let allStores: [Store] = self.mall.stores
        
        
        if self.searchController.searchBar.text == nil || self.searchController.searchBar.text == "" {
            inSearchMode = false
        } else {
            inSearchMode = true
            
            let lowerText = self.searchController.searchBar.text!.lowercaseString
            
            filteredStores = allStores.filter({ (theStore: Store) -> Bool in
                theStore.name.lowercaseString.rangeOfString(lowerText) != nil
            })
        }
        
        storesTableview.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
    
    // MARK: - Tableview Delegate/Datasource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // This will scroll table to top on every reload()
        self.storesTableview.contentOffset = CGPoint(x: 0, y: 0)
        
        if inSearchMode || inFilterMode {
            return filteredStores.count
        }
        
        return mall.stores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
         var store: Store! // = mall.stores[indexPath.row]
         
         if inSearchMode {
         store = filteredStores[indexPath.row]
         } else {
         store = mall.stores[indexPath.row]
         }
         
         if let cell = storesTableview.dequeueReusableCellWithIdentifier("storeCell", forIndexPath: indexPath) as? StoreCell {
         
         cell.configure(store)
         
         return cell
         
         } else {
         
         let cell = StoreCell()
         cell.configure(store)
         
         return cell
         }
         
         */
        
        var store: Store! // = mall.stores[indexPath.row]
        
        if inSearchMode || inFilterMode {
            store = filteredStores[indexPath.row]
        } else {
            store = mall.stores[indexPath.row]
        }
        
        // Class registration with class name
        let cellClassRegisterIdentifier: String = "StoreCell"
        
        // Cell reuse id
        let cellReuseIdentifier: String = "storeCell"
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as? StoreCell {
            cell.configure(store)
            return cell
        } else {
            
            tableView.registerNib(UINib(nibName: cellClassRegisterIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
            
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as? StoreCell {
                cell.configure(store)
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let storeCell = cell as? StoreCell {
            storeCell.request?.cancel()
            print("Cell is not visible anymore")
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        var store: Store!
        
        if inSearchMode {
            store = filteredStores[indexPath.row]
        } else {
            store = mall.stores[indexPath.row]
        }
        
        performSegueWithIdentifier("showStoreDetail", sender: store)
        
    }
    
    // MARK: - Swipe Menu Delegate Methods
    func swipeTabMenuDidSelectItem(menu: SwipeTabMenu, index: Int) {
        //
        print("\(menu.menuArray[index].0) selected")
    }
    
    
}
