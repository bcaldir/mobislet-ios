//
//  SecondViewController.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 15/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
       
        @IBOutlet var titleLabel: UILabel!
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            titleLabel.text = "Second VC"
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}
