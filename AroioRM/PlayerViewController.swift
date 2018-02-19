//
//  PlayerViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import McPicker
import SwiftWebVC

class PlayerView: UIView, UITextFieldDelegate {
    
    //MARK: Properties
    
    var lmsServerName: String = ""
    
    @IBOutlet weak var servernameTextField: UITextField!
    @IBOutlet weak var serveruserTextField: UITextField!
    @IBOutlet weak var serverpasswordTextField: UITextField!
    @IBOutlet weak var serverportTextField: UITextField!
    @IBOutlet weak var audioPlayerButton: UIButton!
    
    override func awakeFromNib() {
        
        servernameTextField.delegate = self
        servernameTextField.tag = 0
        servernameTextField.returnKeyType =  .next
        
        serveruserTextField.delegate = self
        serveruserTextField.tag = 1
        serveruserTextField.returnKeyType = .next
        
        serverpasswordTextField.delegate = self
        serverpasswordTextField.tag = 2
        serverpasswordTextField.returnKeyType =  .next
        
        serverportTextField.delegate = self
        serverportTextField.returnKeyType = .done
        serverportTextField.tag = 3
        serverportTextField.keyboardType = .phonePad

        self.servernameTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "SERVERNAME")
        self.serveruserTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "SQUEEZEUSER")
        self.serverpasswordTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "SQUEEZEPWD")
        self.serverportTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "SERVERPORT")
        self.audioPlayerButton.setTitle(AroioObject.aroio?.getUserconfigParameter(request: "AUDIOPLAYER"), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Actions
    
    @IBAction func hostnameTextFieldEditingDidEnd(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "SERVERNAME", newValue: servernameTextField.text!)
    }
    @IBAction func usernameTextFieldEditingDidEnd(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "SQUEEZEUSER", newValue: serveruserTextField.text!)
    }
    @IBAction func passwordTextFieldEditingDidEnd(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "SQUEEZEPWD", newValue: serverpasswordTextField.text!)
    }
    @IBAction func portTextFieldEditingDidEnd(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "SERVERPORT", newValue: serverportTextField.text!)
    }
    @IBAction func lmsWebinterfaceButtonPressed(_ sender: UIButton) {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let webVC = SwiftModalWebVC(urlString: self.servernameTextField.text!)
        rootVC?.present(webVC, animated: true, completion: nil)
    }
    @IBAction func playerButton(_ sender: UIButton) {
        let data: [[String]] = [
            ["Squeezelite", "UPNP-Player", "Netjack"]
        ]
        
        let playerPicker = McPicker(data: data)
        playerPicker.toolbarButtonsColor = .white
        playerPicker.toolbarBarTintColor = UIColor(red:0.00, green:0.67, blue:0.67, alpha:1.0)
        
        playerPicker.show { selections in
            if let _ = selections[0], let name = selections[1] {
                self.audioPlayerButton.setTitle(name, for:[])
                AroioObject.aroio?.sendRequestToSocket(request: "AUDIOPLAYER", newValue: name)
            }
            
        }
    }
    
    //MARK: Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

class PlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
