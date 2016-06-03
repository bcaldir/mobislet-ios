//
//  RightSliderViewController.swift
//  Mobislet
//
//  Created by Bedirhan Caldir on 10/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class RightSliderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var menuItems : [String] = ["Profilim", "Yardım", "Ayarlar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RightSliderCell", forIndexPath: indexPath) as! RightSliderTableViewCell
        cell.cellLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        switch (indexPath.row){
        case 0: // Profilim has been clicked
            appDelegate.createAndShowNavigationToMenuViewControllerWithRightSlider(self.storyboard?.instantiateViewControllerWithIdentifier("ProfilePageVC") as! ProfilePageViewController, toggleRightSlider : true)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            break;
        case 1: // Yardim has been clicked
            
            break;
        case 2: // Ayarlar has been clicked
            appDelegate.createAndShowNavigationToMenuViewControllerWithRightSlider(self.storyboard?.instantiateViewControllerWithIdentifier("SettingsVC") as! SettingsViewController, toggleRightSlider: true)
            break;
        default: // Error maybe??
            
            break;
        }
    }
    
    @IBAction func notificationsButtonPressed(sender: AnyObject) {
        
    }
    

}
