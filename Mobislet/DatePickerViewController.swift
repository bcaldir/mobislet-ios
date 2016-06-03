//
//  DatePickerViewController.swift
//  Mobislet
//
//  Created by Bedirhan Caldir on 15/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var datePicked: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePickerView.layer.cornerRadius = 10
        datePickerView.layer.borderColor = UIColor.blackColor().CGColor
        datePickerView.layer.borderWidth = 0.25
        datePickerView.layer.shadowColor = UIColor.blackColor().CGColor
        datePickerView.layer.shadowOpacity = 0.6
        datePickerView.layer.shadowRadius = 15
        datePickerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        datePickerView.layer.masksToBounds = false
        
        datePicker.setDate(datePicked, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveDatePicked (){
        datePicked = datePicker.date
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
