//
//  UpdateViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import SwiftWebVC

class UpdateView: UIView {
    
    //MARK: Properties
    
    @IBOutlet weak var betaSwitch: UISwitch!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var updateVersionLabel: UILabel!
    let rootVC = UIApplication.shared.keyWindow?.rootViewController
    var beta: String = "OFF\n"
    
    override func awakeFromNib() {

        self.beta = (AroioObject.aroio?.getUserconfigParameter(request: "USEBETA"))!
        if beta == "ON\n" {
            self.betaSwitch.isOn = true
           // self.updateVersionLabel.text = AroioObject.aroio?.getUserconfigParameter(request: "UPDATECHECKBETA")
        } else {
            self.betaSwitch.isOn = false
          //  self.updateVersionLabel.text = AroioObject.aroio?.getUserconfigParameter(request: "UPDATECHECK")
        }
        self.currentVersionLabel.text = AroioObject.aroio?.getUserconfigParameter(request: "UPDATELOCAL")

        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Actions

    @IBAction func newsButtonPressed(_ sender: UIButton) {
        
        let webVC = SwiftModalWebVC(urlString: "https://www.abacus-electronics.de/produkte/streaming/aroioos.html#aroionews")
        self.rootVC?.present(webVC, animated: true, completion: nil)

    }
    @IBAction func checkBeta(_ sender: UISwitch) {
        
        if self.betaSwitch.isOn == false {
            AroioObject.aroio?.sendRequestToSocket(request: "USEBETA", newValue: "OFF")
            self.beta = "OFF\n"
        } else {
            AroioObject.aroio?.sendRequestToSocket(request: "USEBETA", newValue: "ON")
            self.beta = "ON\n"
        }
    }
    
    @IBAction func checkVersionPressed(_ sender: UIButton) {

        self.currentVersionLabel.text = AroioObject.aroio?.getUserconfigParameter(request: "UPDATELOCAL")
        
        if self.beta == "ON\n" {
            print("beta is ON")

            self.updateVersionLabel.text =  AroioObject.aroio?.getUserconfigParameter(request: "UPDATECHECKBETA").components(separatedBy: "\\").first
            
        } else {
            print("beta is OFF")
            self.updateVersionLabel.text = AroioObject.aroio?.getUserconfigParameter(request: "UPDATECHECK")
        }
    }
    
    @IBAction func runUpdatePressed(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Systemupdate", message: "Soll das Update wirklich ausgeführt werden?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            AroioObject.aroio?.getUserconfigParameter(request: "UPDATEUPDATE")
        }
        let cancelAction = UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.rootVC?.present(alertController, animated: true, completion: nil)
    }
}

class UpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
