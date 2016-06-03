//
//  SettingsFirstTableViewCell.swift
//  Mobislet
//
//  Created by Bedirhan Caldir on 14/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit

class SettingsFirstTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func switchStatus() -> Bool {
        return cellSwitch.on
    }

}
