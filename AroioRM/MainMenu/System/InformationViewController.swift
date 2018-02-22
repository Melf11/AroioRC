//
//  InformationViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit

class InformationView: UIView {

    //MARK: Properties
    
    @IBOutlet weak var systemRuntimeLabel: UILabel!
    @IBOutlet weak var squeezeServerLabel: UILabel!
    @IBOutlet weak var macLanLabel: UILabel!
    @IBOutlet weak var macWiFiLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    
    override func awakeFromNib() {
        
        self.systemRuntimeLabel.text = AroioObject.aroio?.getUserconfigValue(value: "UPTIME")
        
        let squeezeAddr = AroioObject.aroio?.getUserconfigValue(value: "LMSADDRESS")
        
        if squeezeAddr != "" {
            self.squeezeServerLabel.text = squeezeAddr
        } else {
            self.squeezeServerLabel.text = "Kein Squeezeserver vorhanden"
        }
        
        if AroioObject.aroio?.getUserconfigValue(value: "CARRIERSTATE") == "1\n" {
            self.macLanLabel.text = AroioObject.aroio?.getUserconfigValue(value: "MACLAN")
            self.macWiFiLabel.text = "Keine WiFi Verbindung"
        } else {
            self.macWiFiLabel.text = AroioObject.aroio?.getUserconfigValue(value: "MACWIFI")
            self.macLanLabel.text = "Keine LAN Verbindung"
        }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Actions
    //TODO: Find a way to get the logs from aroioOS
    @IBAction func shairportLogPressed(_ sender: UIButton) {
    }
    @IBAction func systemLogPressed(_ sender: UIButton) {
    }
    @IBAction func fileSystemPressed(_ sender: UIButton) {
    }
    @IBAction func networkOverviewPressed(_ sender: UIButton) {
    }
    @IBAction func squeezeliteLogPressed(_ sender: UIButton) {
    }
    @IBAction func storageUsagePressed(_ sender: UIButton) {
    }
}

class InformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
