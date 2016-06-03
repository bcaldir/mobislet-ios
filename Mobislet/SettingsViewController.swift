//
//  SettingsViewController.swift
//  Mobislet
//
//  Created by Bedirhan Caldir on 14/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var menuItemsFirstGroup : [String] = ["Bildirimler"]
    var menuItemsSecondGroup : [String] = ["Hakkımızda", "Sözleşme", "Gizlilik Politikası"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        for i in 0..<menuItemsFirstGroup.count {
            let cell = table.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! SettingsFirstTableViewCell
            switch (i) {
            case 0: // For Bildirimler
                cell.switchStatus() // read the switch status, do whatever has to be done
                break;
            default:
                break;
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuItemsFirstGroup.count
        } else if section == 1 {
            return menuItemsSecondGroup.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsFirstCell", forIndexPath: indexPath) as! SettingsFirstTableViewCell
            cell.cellLabel.text = menuItemsFirstGroup[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsSecondCell", forIndexPath: indexPath) as! SettingsSecondTableViewCell
            cell.cellLabel.text = menuItemsSecondGroup[indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            let textVC = self.storyboard?.instantiateViewControllerWithIdentifier("TextVC") as! TextViewController
            appDelegate.createAndShowNavigationToMenuViewControllerWithRightSlider(textVC, toggleRightSlider : false)
            switch (indexPath.row){
            case 0: // Hakkımızda has been clicked
                textVC.text = "Hakkimizda"
                break;
            case 1: // Sözleşme has been clicked
                textVC.text = "Sözleşme"
                break;
            case 2: // Gizlilik Politikası has been clicked
                textVC.text = "Gizlilik Politikası"
                break;
            default: // Error maybe??
                break;
            }
        }
        
    }

}
