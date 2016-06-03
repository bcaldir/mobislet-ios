//
//  ViewController.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 14/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit
import MMDrawerController

class MenuViewController: UIViewController {
    
    private var menuHeight: CGFloat = 50
    private var menuWidth: CGFloat = 50
    private var scaleParameter: CGFloat = 1.0 {
        didSet {
            menuHeight *= scaleParameter
        }
    }
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleParameter = UTILS.menuScaleFactor
        /*
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MenuViewController.didTapGoToLeft))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MenuViewController.didTapGoToRight))
         */
        
        // MARK: - Scroll menu setup
        
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        
        let discoveryVC: DiscoveryViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DiscoveryVC") as! DiscoveryViewController
        discoveryVC.title = "home"
        controllerArray.append(discoveryVC)
        
        
        
        let firstVC: FirstViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FirstVC") as! FirstViewController
        firstVC.title = "like"
        // controllerArray.append(firstVC)
        
        
        /*
        let secondVC: SecondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondVC") as! SecondViewController
        secondVC.title = "like"
        controllerArray.append(secondVC)
        */
        
        let tabbarVC: UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabbarVC") as! UITabBarController
        tabbarVC.title = "like"
        controllerArray.append(tabbarVC)
        
        /*
        
        let controller3 : TestViewController = TestViewController(nibName: "TestViewController", bundle: nil)
        controller3.title = "home"
        controllerArray.append(controller3)
        let controller4 : TestViewController = TestViewController(nibName: "TestViewController", bundle: nil)
        controller4.title = "search"
        controllerArray.append(controller4)
        //controllerArray.append(controller4)
        //controllerArray.append(controller4)
        */
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(CONSTANTS.colorAppBackground),
            //.ViewBackgroundColor(CONSTANTS.colorAppBackground),
            .SelectionIndicatorColor(CONSTANTS.colorAppMain),
            .BottomMenuHairlineColor(CONSTANTS.colorAppDarkerBackground),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(22.0 + menuHeight),
            .MenuItemWidth(menuHeight),
            .CenterMenuItems(false)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        self.view.sendSubviewToBack(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden  = true
        self.navigationController?.navigationBar.hidden  = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.Default
    }
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    @IBAction func rightSliderActivated(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
}








