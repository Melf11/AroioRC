//
//  MenuViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 06.06.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import os.log

// Colors für PageMenu

let lightGrey = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
let lightBlue = UIColor(red:0.00, green:0.75, blue:0.75, alpha:1.0)
let darkRed  = UIColor(red:0.70, green:0.10, blue:0.10, alpha:1.0)

class MenuViewController: UITabBarController {
   
 
    //Method mainly to initiate and pass data from AroioTableView to the whole menu
    override func viewDidLoad() {

        super.viewDidLoad()

        if (AroioObject.aroio?.connectToSocket())! {
            let alert = UIAlertController(title: "Verbindungsstatus", message: "Die Verbindung zum \(AroioObject.aroio?.hostName ?? "Aroio") ist aufgebaut.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            os_log("socket connection successful", log: OSLog.default, type: .debug)
        } else {

            let alert = UIAlertController(title: "Verbindungsstatus", message: "Die Verbindung zum \(AroioObject.aroio?.hostName ?? "Aroio") kann nicht aufgebaut werden. Bitte die Netzwerkverbindung des \(AroioObject.aroio?.hostName ?? "Aroio") checken und ggf. das Gerät erneut hinzufügen anhand der \"Finde Aroio's\"-Funktion", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { action in
                
                self.navigationController?.navigationBar.barTintColor = darkRed
                self.navigationController?.navigationBar.topItem?.title = "Nicht mit \(AroioObject.aroio?.hostName ?? "Aroio") verbunden"
            }))
            self.present(alert, animated: true, completion: nil)
            os_log("socket connection failure", log: OSLog.default, type: .error)
        }
        
        self.navigationItem.title  = AroioObject.aroio?.hostName
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToAroioMenu(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AroioTableConfigViewController{
            
            let aroioTemp = sourceViewController.aroio
            AroioObject.aroio?.disconnectFromSocket()
            AroioObject.aroio = aroioTemp
            os_log("disconnect 'unwindToAroioMenu'", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed 'unwindToAroioMenu'", log: OSLog.default, type: .error)
        }
   

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
    }
    
}
