//
//  CovolverModulViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import McPicker

class ConvolverView: UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    //MAKR: Properties
    
    //Variable for active Filter
    var defCoeff: String = ""
    var defCoeffInt: Int  = 0
    
    var filterPickerData: [[String]] = [[]]
    
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
        
        let nibName = UINib(nibName: "BankTableViewCell", bundle: nil)
        bankTableView.register(nibName, forCellReuseIdentifier: "BankTableViewCell")
        
        //Cast active Filter Variable to int for tableRow
        
        defCoeff = (AroioObject.aroio?.getUserconfigParameter(request: "DEF_COEFF"))!
        if defCoeff != "" {
            defCoeffInt = Int(String(defCoeff.filter { !" \n".contains($0) }))!
        }
     
        addFilterPickerData()
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
        
        cell.bankNoteTextField.text = (AroioObject.aroio?.getUserconfigParameter(request: "COEFF_COMMENT\(indexPath.row)"))!
        cell.bankFilterSelectionButton.setTitle((AroioObject.aroio?.getUserconfigParameter(request: "COEFF_NAME\(indexPath.row)"))!, for: .normal)
        cell.bankVolumeTextField.text = (AroioObject.aroio?.getUserconfigParameter(request: "COEFF_ATT\(indexPath.row)"))!

        cell.bankSwitch.tag = indexPath.row
        cell.bankSwitch.addTarget(self, action: #selector(ConvolverView.bankSwitchChanged), for: .valueChanged)
        
        cell.bankNoteTextField.tag = indexPath.row
        cell.bankNoteTextField.addTarget(self, action: #selector(ConvolverView.bankNoteTextFieldEditingDidEnd), for: .editingDidEnd)
        cell.bankNoteTextField.returnKeyType = .done
        
        cell.bankFilterSelectionButton.tag = indexPath.row
        cell.bankFilterSelectionButton.addTarget(self, action: #selector(ConvolverView.bankFilterSelectionButtonPressed), for: .touchUpInside)
        
        cell.bankVolumeTextField.tag = indexPath.row
        cell.bankVolumeTextField.addTarget(self, action: #selector(ConvolverView.bankVolumeTextFieldEditingDidEnd), for: .editingDidEnd)
        cell.bankVolumeTextField.keyboardType = .numberPad
        cell.bankVolumeTextField.returnKeyType = .done
        
        return cell
    }

    @objc func bankSwitchChanged(sender: UISwitch) {

        var index = 0
        for cell in self.bankTableView.visibleCells {
            let customCell = cell as? BankTableViewCell
            if index == sender.tag  {
                AroioObject.aroio?.sendRequestToSocket(request: "DEF_COEFF", newValue: String(sender.tag))
                customCell?.bankSwitch.isOn = true
                print("cell with tag: \(sender.tag)")
            } else {
                customCell?.bankSwitch.isOn = false
            }
            index += 1
        }
  }
    @objc func bankNoteTextFieldEditingDidEnd(sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "COEFF_COMMENT\(sender.tag)", newValue: sender.text!)
    }
    @objc func bankFilterSelectionButtonPressed(sender: UIButton) {

        let filterPicker = McPicker(data: self.filterPickerData)
        filterPicker.toolbarButtonsColor = .white
        filterPicker.toolbarBarTintColor = UIColor(red:0.00, green:0.50, blue:0.50, alpha:1.0)

        filterPicker.show {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                sender.setTitle(name, for: .normal)
                AroioObject.aroio?.sendRequestToSocket(request: "COEFF_NAME\(sender.tag)", newValue: name)
            }
        }
        
    }
    @objc func bankVolumeTextFieldEditingDidEnd(sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "COEFF_ATT\(sender.tag)", newValue: sender.text!)
    }
    
    func addFilterPickerData(){
        let filterString = (AroioObject.aroio?.getData(request: "LS"))!
        var filterArray = filterString.components(separatedBy: ".dbl\n")
 
        var index = 0
        for string in filterArray {
            if (string.range(of: "R96") != nil){
                filterArray.remove(at: index + 1)
                self.filterPickerData[0].append(filterArray[index].replacingOccurrences(of: "L96", with: ""))
                index += 1
            }
        }
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
