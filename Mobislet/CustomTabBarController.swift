//
//  CustomTabBarController.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 12/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let's create several View Controllers
        
        let discovery = self.createViewcontrollerWithStoryBoardID(CONSTANTS.STORYBOARDID_DISCOVERY) as! UINavigationController
       
        let favourites = self.createViewcontrollerWithStoryBoardID(CONSTANTS.STORYBOARDID_FAVOURITES) as! UINavigationController
        
        //discovery.title = "Keşfet"
        // favourites.title = "Favoriler"

        let controllers = [discovery, favourites]
        // populate our tab bar controller with the above
        self.setViewControllers(controllers, animated: true)
        
        
        
        let discTabBarItem: UITabBarItem = self.tabBar.items![0]
        let favTabBarItem: UITabBarItem = self.tabBar.items![1]
        
        
        //  discTabBarItem.title = "Keşfet"
        // favTabBarItem.title = "Favoriler"
        
        discTabBarItem.selectedImage = UIImage(named: "discovery_tab_selected")
        discTabBarItem.image = UIImage(named: "discovery_tab_unselected")
        discTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        

        favTabBarItem.selectedImage = UIImage(named: "favorites_tab_selected")
        favTabBarItem.image = UIImage(named: "favorites_tab_unselected")
        favTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        self.tabBar.backgroundColor = CONSTANTS.colorAppLightGray
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : CONSTANTS.colorAppMain]
            , forState: .Normal)
        
        // let titleHighlightedColor: UIColor = UIColor(red: 153 / 255.0, green: 192 / 255.0, blue: 48 / 255.0, alpha: 1.0)
        // UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : CONSTANTS.colorAppMain], forState: .Highlighted)
        
        /*
        //create a custom view for the tab bar
        let frame: CGRect = CGRectMake(300.0, 0.0, self.view.bounds.size.width, 48)
        let v: UIView = UIView(frame: frame)
        v.backgroundColor = UIColor.yellowColor()
        v.alpha = 0.5
        self.tabBar.addSubview(v)
        */
        /*
        //set the tab bar title appearance for normal state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(16.0)], forState: .Normal)
        //set the tab bar title appearance for selected state
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blueColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(16.0)], forState: .Highlighted)
        
        */
        
        // self.tabBar.addSubview()

        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createViewcontrollerWithStoryBoardID(storyboardID: String) -> UIViewController {
        let newViewcontroller: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(storyboardID)
        return newViewcontroller;
    }
    
    
    

}
