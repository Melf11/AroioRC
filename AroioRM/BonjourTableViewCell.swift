//
//  BonjourTableViewCell.swift
//  AroioRM
//
//  Created by Melf Stöcken on 31.05.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import os.log

class BonjourTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var hostNameLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
