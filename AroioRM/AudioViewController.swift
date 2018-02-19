//
//  AudioViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import McPicker
import os.log


class AudioView: UIView, UITextFieldDelegate{
    
    //MARK: Properties
    
    @IBOutlet weak var playerNameTextField: UITextField! = UITextField()
    @IBOutlet weak var cleanSwitch: UISwitch!
    @IBOutlet weak var convolutionSwitch: UISwitch!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var jackPuffer: UIButton!
    @IBOutlet weak var soundDevice: UIButton!
    @IBOutlet weak var hardwareEnvironmentButton: UIButton!
    
    
    
    override func awakeFromNib() {
        
        playerNameTextField.delegate = self
        playerNameTextField.returnKeyType = .done
        
        self.playerNameTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "PLAYERNAME")
        self.volumeButton.setTitle(AroioObject.aroio?.getUserconfigParameter(request: "VOLUME"), for: .normal)
        self.jackPuffer.setTitle(AroioObject.aroio?.getUserconfigParameter(request: "JACKPUFFER"), for: .normal)
        self.soundDevice.setTitle(AroioObject.aroio?.getUserconfigParameter(request: "SOUNDCARD"), for: .normal)
        self.hardwareEnvironmentButton.setTitle(AroioObject.aroio?.getUserconfigParameter(request: "PLATFORM"), for: .normal)
        
        let clean: String = (AroioObject.aroio?.getUserconfigParameter(request: "MSCODING"))!
        
        if clean == "ON\n" {
            self.cleanSwitch.isOn = true
        } else {
            self.cleanSwitch.isOn = false
        }
        
        let brutefir = (AroioObject.aroio?.getUserconfigParameter(request: "BRUTEFIR"))!
        
        if brutefir == "ON\n" {
            self.convolutionSwitch.isOn = true
        } else {
            self.convolutionSwitch.isOn = false
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.playerNameTextField.text = AroioObject.aroio?.playerName
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.playerNameTextField.text = AroioObject.aroio?.playerName
    }
    

    
    //MARK: Text Field Methods
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "PLAYERNAME", newValue: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    @IBAction func changeCleaner(_ sender: UISwitch) {
        if self.cleanSwitch.isOn == false {
            AroioObject.aroio?.sendRequestToSocket(request: "MSCODING", newValue: "OFF")
        } else {
            AroioObject.aroio?.sendRequestToSocket(request: "MSCODING", newValue: "ON")
        }
    }
    
    @IBAction func changeConvolution(_ sender: UISwitch) {
        if self.convolutionSwitch.isOn == false {
            AroioObject.aroio?.sendRequestToSocket(request: "BRUTEFIR", newValue: "OFF")
        } else {
            AroioObject.aroio?.sendRequestToSocket(request: "BRUTEFIR", newValue: "ON")
        }
    }
    
    @IBAction func volumeButton(_ sender: UIButton) {
        
        let data: [[String]] = [
            ["0dB", "-1dB", "-2dB", "-3dB", "-4dB", "-5dB", "-6dB", "-12dB"]
        ]
        
        let volumePicker = McPicker(data: data)
        volumePicker.toolbarButtonsColor = .white
        volumePicker.toolbarBarTintColor = UIColor(red:0.00, green:0.50, blue:0.50, alpha:1.0)
        
        
        volumePicker.show {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self.volumeButton.setTitle(name, for: .normal)
                AroioObject.aroio?.sendRequestToSocket(request: "VOLUME", newValue: name)
            }
        }
    }
    
    @IBAction func jackPuffer(_ sender: UIButton) {
        
        let data: [[String]] = [["8192", "4096", "2048"]]
        
        let jackPicker = McPicker(data: data)
        jackPicker.toolbarButtonsColor = .white
        jackPicker.toolbarBarTintColor = UIColor(red:0.00, green:0.67, blue:0.67, alpha:1.0)
        
        jackPicker.show {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self.jackPuffer.setTitle(name, for: .normal)
                AroioObject.aroio?.sendRequestToSocket(request: "JACKBUFFER", newValue: name)
            }
        }
    }
    
    @IBAction func soundDevice(_ sender: UIButton) {
        
        let data: [[String]] = [["AroioDAC","IQAudioDAC", "HifiBerryDAC", "HifiBerryDAC+", "RMEFirefaceUCX"]]
        
        let soundPicker = McPicker(data: data)
        soundPicker.toolbarButtonsColor = .white
        soundPicker.toolbarBarTintColor = UIColor(red:0.00, green:0.67, blue:0.67, alpha:1.0)
        
        soundPicker.show {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self.soundDevice.setTitle(name, for: .normal)
                AroioObject.aroio?.sendRequestToSocket(request: "SOUNDCARD", newValue: name)
            }
        }
    }
    @IBAction func hardwareEnvironment(_ sender: UIButton) {
        
        
        let data: [[String]] = [["AroioLT","AroioSU", "AroioSU"]]
        
        let soundPicker = McPicker(data: data)
        soundPicker.toolbarButtonsColor = .white
        soundPicker.toolbarBarTintColor = UIColor(red:0.00, green:0.67, blue:0.67, alpha:1.0)
        
        soundPicker.show {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self.soundDevice.setTitle(name, for: .normal)
                AroioObject.aroio?.sendRequestToSocket(request: "PLATFORM", newValue: name)
            }
        }
    }

}



class AudioViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
