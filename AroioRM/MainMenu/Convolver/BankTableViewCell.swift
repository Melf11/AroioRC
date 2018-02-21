//
//  BankTableViewCell.swift
//  AroioRM
//
//  Created by Melf Stöcken on 15.02.18.
//  Copyright © 2018 ABACUS electronics. All rights reserved.
//

import UIKit

class BankTableViewCell: UITableViewCell {
  //MARK: Properties

    @IBOutlet weak var bankSwitch: UISwitch!
    @IBOutlet weak var bankNoteTextField: UITextField!
    @IBOutlet weak var bankFilterSelectionButton: UIButton!
    @IBOutlet weak var bankVolumeTextField: UITextField!

    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

