//
//  TextViewController.swift
//  Mobislet
//
//  Created by Bedirhan Caldir on 16/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.text = text
    }

}
