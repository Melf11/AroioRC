//
//  AddNewAroioViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 04.09.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import NetworkExtension
import SwiftSocket
import os.log

class AddNewAroioViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reconnectButton: UIButton!
    
    // Socket Connection just for wifi hotspot configuration
    let client = TCPClient(address: "192.168.99.1", port: 4444)

    
    //MARK: Actions
    
    @IBAction func reconnectToWiFi(_ sender: UIButton) {

        //Disconnect will sleep for 1 Sek that the response has time for sending

        let response = "response;REBOOT;default\n"
        let data = response.data(using: String.Encoding.utf8)!

        switch self.client.send(data: data) {
        case .success:
            os_log("Send 'response' successful and restart networking", log: OSLog.default, type: .debug)
            
            let alert = UIAlertController(title: "WLAN Kofiguriert", message: "Das WLAN ihres Aroio ist nun konfiguriert und das System wird neugestartet, bitte fügen Sie den Aroio nach etwa 30 Sekungen mit der \"Aroio's Suchen\"-Funktion hinzu." , preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            _ = navigationController?.popViewController(animated: true)
            disconnectFromSocket()
            
        case .failure(let error):
            os_log("Could not send 'response' to server.", log: OSLog.default, type: .error)
            print(error)
        }
    }
    
    @IBAction func ssidTextFieldEditingDidEnd(_ sender: UITextField) {
       
        let response = "change;WLANSSID;\(self.ssidTextField.text!)\n"
        let data = response.data(using: String.Encoding.utf8)!
        
        switch self.client.send(data: data) {
        case .success:
            os_log("Send 'change' successful and switch", log: OSLog.default, type: .debug)
            
        case .failure(let error):
            os_log("Could not send 'request' to server.", log: OSLog.default, type: .error)
            print(error)
        }
   
    }
    
    @IBAction func passwordTextFieldEditingDidEnd(_ sender: UITextField) {
        
        let response = "change;WLANPWD;\(self.passwordTextField.text!)\n"
        let data = response.data(using: String.Encoding.utf8)!
        
        switch self.client.send(data: data) {
        case .success:
            os_log("Send 'change' successful and switch", log: OSLog.default, type: .debug)
            
            reconnectButton.isUserInteractionEnabled = true
            reconnectButton.tintColor = UIColor.red
            
        case .failure(let error):
            os_log("Could not send 'request' to server.", log: OSLog.default, type: .error)
            print(error)
        }
        
    }
    
    @IBAction func ScanForWifiButton(_ sender: UIButton) {

        
        /************************************************************************/
        //MARK: for iOS 10 or lower
        /*
         * comment "import NetworkExtension" (line 10)
         * Change Projekt to iOS 10
         * Change Target to "DeploymentTarget iOS 10"
         * Disable "Hotspot Configuration" from Target's Capabilities
         * Clean Projekt
         */
        
        //uncomment following 3 lines
        /*
        let url = URL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared
        app.openURL(url!)
        */
        
        /************************************************************************/
        //MARK: from iOS 11
        /*
         * uncomment "import NetworkExtension"
         * Change Projekt to iOS 11
         * Change Target to "DeploymentTarget iOS 11"
         * Enable "Hotspot Configuration" from Target's Capabilities
         * Clean Projekt
         */
        /************************************************************************/
        
        let aroioHotspotConfig = NEHotspotConfiguration(ssid: "AroioAP", passphrase: "AroioWIFI", isWEP: false)
        
        aroioHotspotConfig.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(aroioHotspotConfig) { error in
 
            if error != nil {
                if error?.localizedDescription == "already associated."
                {
                    print("already Connected to AroioAP")
                    self.connectToSocket()
                    
                    let alert = UIAlertController(title: "Verbindungsstatus", message: "Die Verbindung zum AroioAP-Hotspot ist nun aufgebaut und die Zugangsdaten können eingetragen werden." , preferredStyle: UIAlertControllerStyle.alert)

                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    print("No Connected")
                }
            }
            else {
                print("Connected to AroioAP")
                sleep(1)
                self.connectToSocket()
                let alert = UIAlertController(title: "Verbindungsstatus", message: "Die Verbindung zum AroioAP-Hotspot ist nun aufgebaut und die Zugangsdaten können eingetragen werden." , preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
       
       
    }
    
    func connectToSocket(){
        
        switch self.client.connect(timeout: 1){
        case .success:
            
            print("socket connected")
            ssidTextField.isUserInteractionEnabled = true
            passwordTextField.isUserInteractionEnabled = true
            
    
        case .failure(let error):
            
            print("socket connection failed")
            ssidTextField.isUserInteractionEnabled = false
            passwordTextField.isUserInteractionEnabled = false
        }
    }
    
    func disconnectFromSocket(){
        client.close()
        os_log("Socket Client successfully closed.", log: OSLog.default, type: .debug)
    }
    
    //MARK: Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ssidTextField.delegate = self
        passwordTextField.delegate = self
        
        
        ssidTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        
        ssidTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        ssidTextField.tag = 0
        passwordTextField.tag = 1
        
        reconnectButton.isUserInteractionEnabled = false
        reconnectButton.tintColor = lightGrey
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
