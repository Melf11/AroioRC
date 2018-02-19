//
//  NetworkViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit

class NetworkView: UIView, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var hostnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dhcpSwitch: UISwitch!
    @IBOutlet weak var staticIpView: UIView!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var netmaskTextField: UITextField!
    @IBOutlet weak var gatewayTextField: UITextField!
    @IBOutlet weak var dnsTextField: UITextField!
    let rootVC = UIApplication.shared.keyWindow?.rootViewController
    
    override func awakeFromNib() {
        
        hostnameTextField.delegate = self
        hostnameTextField.returnKeyType = .done
        hostnameTextField.tag = 0
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.tag = 1
        
        ipTextField.delegate = self
        ipTextField.returnKeyType = .next
        ipTextField.keyboardType = UIKeyboardType.phonePad
        ipTextField.tag = 2
        
        netmaskTextField.delegate = self
        netmaskTextField.returnKeyType = .next
        netmaskTextField.keyboardType = UIKeyboardType.phonePad
        netmaskTextField.tag = 3
        
        gatewayTextField.delegate = self
        gatewayTextField.returnKeyType = .next
        gatewayTextField.keyboardType = UIKeyboardType.phonePad
        gatewayTextField.tag = 4
        
        dnsTextField.delegate = self
        dnsTextField.returnKeyType = .done
        dnsTextField.keyboardType = UIKeyboardType.phonePad
        dnsTextField.tag = 5
        
        
        self.hostnameTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "HOSTNAME")
        self.passwordTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "USERPASSWD")
        self.ipTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "IPADDR")
        self.netmaskTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "NETMASK")
        self.gatewayTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "GATEWAY")
        self.dnsTextField.text = AroioObject.aroio?.getUserconfigParameter(request: "DNSSERV")
        
        let dhcp: String = (AroioObject.aroio?.getUserconfigParameter(request: "DHCP"))!
        if dhcp == "ON\n" {
            self.dhcpSwitch.isOn = true
            self.staticIpView.isHidden = true
        } else {
            self.dhcpSwitch.isOn = false
            self.staticIpView.isHidden = false
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //   commonInit()
    }
    
    //MARK: Actions
    
    @IBAction func dhcpSwitch(_ sender: UISwitch) {
        if self.dhcpSwitch.isOn == true {
            self.staticIpView.isHidden = true
            AroioObject.aroio?.sendRequestToSocket(request: "DHCP", newValue: "ON")
        } else {
            self.staticIpView.isHidden = false
            AroioObject.aroio?.sendRequestToSocket(request: "DHCP", newValue: "OFF")
        }
        
    }
    
    @IBAction func hostnameTextFieldDidEndEditing(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "HOSTNAME", newValue: hostnameTextField.text!)
    }
    
    @IBAction func passwordTextFieldDidEndEditing(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "USERPASSWD", newValue: passwordTextField.text!)
    }
    
    @IBAction func ipTextFieldDidEndEditing(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "IPADDR", newValue: ipTextField.text!)
    }
    
    @IBAction func gatewayTextFieldDidEndEditing(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "GATEWAY", newValue: gatewayTextField.text!)
    }
    
    @IBAction func maskTextFieldDidEndEditing(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "NETMASK", newValue: netmaskTextField.text!)
    }
    
    @IBAction func dnsTextFieldDidEndEditing(_ sender: UITextField) {
        AroioObject.aroio?.sendRequestToSocket(request: "DNSSERV", newValue: dnsTextField.text!)
    }
    @IBAction func restartNetworkButtonPressed(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Netzwerk neustarten (System Reboot)", message: "Soll das Netzwerk mit den oben angegebenen Einstellungen neu aufgebaut werden?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            AroioObject.aroio?.getUserconfigParameter(request: "REBOOT")
        }
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField.tag < 2 {
            textField.resignFirstResponder()
        } else if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return false
    }

}

class NetworkViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
