//
//  CovolverModulViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import McPicker

class ConvolverView: UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BankTableViewDelegate {
    
    //MAKR: Properties
    
    //Variable for active Filter
    var defCoeff: String = ""
    var defCoeffInt: Int  = 0
    
    var tableCells: [UITableViewCell] = []
    
    let bankTableViewCell: BankTableViewCell? = nil
    
    @IBOutlet weak var convolutionSwitch: UISwitch!
    @IBOutlet weak var preFilterSwitch: UISwitch!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var bankTableView: UITableView!
    
    override func awakeFromNib() {
        
        let brutefir = (AroioObject.aroio?.getUserconfigParameter(request: "BRUTEFIR"))!
        
        if brutefir == "ON\n" {
            self.convolutionSwitch.isOn = true
        } else {
            self.convolutionSwitch.isOn = false
        }
        
        bankTableView.dataSource = self
        bankTableView.delegate = self
        
        bankTableViewCell?.delegate = self
        
        let nibName = UINib(nibName: "BankTableViewCell", bundle: nil)
        bankTableView.register(nibName, forCellReuseIdentifier: "BankTableViewCell")
        
        //Cast active Filter Variable to int for tableRow
        
        defCoeff = (AroioObject.aroio?.getUserconfigParameter(request: "DEF_COEFF"))!
        if defCoeff != "" {
            defCoeffInt = Int(String(defCoeff.filter { !" \n".contains($0) }))!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Actions
    
    @IBAction func convolutionSwitch(_ sender: UISwitch) {
        
        if self.convolutionSwitch.isOn == true {
            self.bankTableView.reloadData()
            AroioObject.aroio?.sendRequestToSocket(request: "BRUTEFIR", newValue: "ON")
        } else {
            self.bankTableView.reloadData()
            AroioObject.aroio?.sendRequestToSocket(request: "BRUTEFIR", newValue: "OFF")
        }
    }
    
    @IBAction func preFilter(_ sender: UISwitch) {
    }
    
    @IBAction func mutePressed(_ sender: UIButton) {
    }
    @IBAction func setParameterPressed(_ sender: UIButton) {
    }
    @IBAction func saveAndReloadPressed(_ sender: UIButton) {
    }
    
    //MARK: Delegate Methods
    
    func bankSwitchTapped(at index: IndexPath) {
        
    }
    
    func bankNoteTextFieldTapped(textField: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "PLAYERNAME", newValue: textField.text!)
    }
    
    func bankFilterSelctionButtonTapped(_ button: UIButton?) {
        AroioObject.aroio?.sendRequestToSocket(request: "TEST", newValue: button!.currentTitle!)
    }
    
    func bankVolumeTextFieldTapped(at index: IndexPath, textField: UITextField) {
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = bankTableView.dequeueReusableCell(withIdentifier: "BankTableViewCell", for: indexPath) as? BankTableViewCell else {
            fatalError("The dequeued cell is not an instance of AroioTableViewCell")
        }
        
        if convolutionSwitch.isOn {
            cell.bankNoteTextField.isEnabled = true
            cell.bankFilterSelectionButton.isEnabled = true
            cell.bankSwitch.isEnabled = true
            cell.bankVolumeTextField.isEnabled = true
        } else {
            cell.bankNoteTextField.isEnabled = false
            cell.bankFilterSelectionButton.isEnabled = false
            cell.bankSwitch.isEnabled = false
            cell.bankVolumeTextField.isEnabled = false
        }
        
        
        if indexPath.row == defCoeffInt {
            cell.bankSwitch.isOn = true
        }
        
        cell.bankNoteTextField.text = (AroioObject.aroio?.getUserconfigParameter(request: "COEFF_NAME\(indexPath.row)"))!
        cell.bankNoteTextField.delegate = self
        
        
        cell.bankFilterSelectionButton.setTitle((AroioObject.aroio?.getUserconfigParameter(request: "COEFF_COMMENT\(indexPath.row)"))!, for: .normal)
        
        cell.bankVolumeTextField.text = "-\((AroioObject.aroio?.getUserconfigParameter(request: "COEFF_ATT\(indexPath.row)"))!)"
        cell.bankVolumeTextField.delegate = self
        
        cell.bankFilterSelectionButton.addTarget(self, action: #selector(ConvolverView.bankFilterSelectionButtonPressed), for: .touchUpInside)
        
        
        tableCells.append(cell)
        return cell
    }
    
    @objc func bankFilterSelectionButtonPressed() {
        print("bankFilterSelectionButtonPressed() was called")
    }
    
    func createTableFunctions(cell: BankTableViewCell) {
        
        //        bankTableView.cellForRow(at: inde)
        
        //TODO: Make Cells writeable
        
    }
    
    
    
    
    
}

class ConvolverModulViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
