//
//  BankTableViewCell.swift
//  AroioRM
//
//  Created by Melf Stöcken on 15.02.18.
//  Copyright © 2018 ABACUS electronics. All rights reserved.
//

import UIKit

protocol BankTableViewDelegate {
    func bankSwitchTapped(at index:IndexPath)
    func bankNoteTextFieldTapped(textField: UITextField)
    func bankFilterSelctionButtonTapped(_ button: UIButton?)
    func bankVolumeTextFieldTapped(at index:IndexPath, textField: UITextField)
}

class BankTableViewCell: UITableViewCell {

    //TODO: Find a way to send change requests from every cell separetly
    
    //MARK: Properties
    
    var delegate: BankTableViewDelegate?
    
    @IBOutlet weak var bankSwitch: UISwitch!
    @IBOutlet weak var bankNoteTextField: UITextField!
    @IBOutlet weak var bankFilterSelectionButton: UIButton!
    @IBOutlet weak var bankVolumeTextField: UITextField!

    var indexPath:IndexPath!

    @IBAction func bankSwitchPressed(_ sender: UISwitch) {
        delegate?.bankSwitchTapped(at: indexPath)
    }
    @IBAction func bankNoteTextFieldUsed(_ sender: UITextField) {
        delegate?.bankNoteTextFieldTapped(textField: sender)
    }
    @IBAction func bankFilterSelectionButton(_ sender: UIButton) {
        delegate?.bankFilterSelctionButtonTapped(sender)
    }
    @IBAction func bankVolumeTextFieldUsed(_ sender: UITextField) {
        delegate?.bankVolumeTextFieldTapped(at: indexPath, textField: sender)
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

