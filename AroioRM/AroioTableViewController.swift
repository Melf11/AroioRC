//
//  AroioTableViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 02.05.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import os.log



class AroioTableViewController: UITableViewController {

    //MARK: Properties
    let navBarColor = UIColor(red:0, green:0.66, blue:0.66, alpha:1.0)
    var aroios = [Aroio]()
    var aroio: Aroio?
    
    private var currentAroio: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Gesture Recognizer for other table elements except the first
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AroioTableViewController.longPress(_:)))
//        self.view.addGestureRecognizer(longPressRecognizer)
//
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AroioTableViewController.tap(_:)))
//        self.view.addGestureRecognizer(tapRecognizer)

        navigationItem.leftBarButtonItem = editButtonItem
        
        self.navigationController?.navigationBar.barTintColor = self.navBarColor
        
        if let saveAroio = loadAroios(){
            
            aroios += saveAroio
            
        } else {
            
            os_log("No Aroio's stored!",  log: OSLog.default, type: .debug)
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aroios.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AroioTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AroioTableViewCell else {
            fatalError("The dequeued cell is not an instance of AroioTableViewCell")
        }
        
        let aroio = aroios[indexPath.row]
        
        cell.contentView.isUserInteractionEnabled = false;
        
        cell.hostNameLabel.text = aroio.hostName

        cell.ipAddrLabel.text = aroio.ipAddr
        cell.playerNameLabel.text = aroio.playerName
        
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            aroios.remove(at: indexPath.row)
            saveAroio()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }

     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        switch (segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new Aroio.", log: OSLog.default, type: .debug)
            
        case "ShowAroioListConfig":
            
            guard let aroioDetailViewController = segue.destination as? AroioTableConfigViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedAroioCell = sender as? AroioTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "undefined Cell")")
            }
            guard let indexPath = tableView.indexPath(for: selectedAroioCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedAroio = aroios[indexPath.row]
            aroioDetailViewController.aroio = selectedAroio
            
        case "ShowAroioMenu":
            
            guard segue.destination is MenuViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedAroioCell = sender as? AroioTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "undefined Cell")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedAroioCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedAroio = aroios[indexPath.row]
            //aroioDetailViewController.aroio = selectedAroio
            AroioObject.aroio = selectedAroio
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "undefined segue identifier")")
        }
        
    }

    //MARK: Actions and Gestures
    
    // functions to recognize gestures on tableview elements, except first one!
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        
        os_log("longPress(_:) used!", log: OSLog.default, type: .debug)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: self.view)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                currentAroio = indexPath
                
                let cell = tableView.cellForRow(at: indexPath)
                
                self.performSegue(withIdentifier: "ShowAroioListConfig", sender: cell)
                
                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        os_log("tap(_:) used!", log: OSLog.default, type: .debug)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: self.view)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                currentAroio = indexPath
                
                let cell = tableView.cellForRow(at: indexPath)
                
                
                self.performSegue(withIdentifier: "ShowAroioMenu", sender: cell)
                
                
            }
        }
    }

    // IBActions just for the first tableViewCell

    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        
        os_log("tap used!", log: OSLog.default, type: .debug)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: self.view)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                currentAroio = indexPath
                
                let cell = tableView.cellForRow(at: indexPath)
                
                self.performSegue(withIdentifier: "ShowAroioMenu", sender: cell)
                
                
            }
        }

        
    }
    @IBAction func didLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        os_log("longPress used!", log: OSLog.default, type: .debug)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: self.view)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                currentAroio = indexPath
                
                let cell = tableView.cellForRow(at: indexPath)
                
                self.performSegue(withIdentifier: "ShowAroioListConfig", sender: cell)
                
            }
        }
        
    }
    


    @IBAction func unwindToAroioList(sender: UIStoryboardSegue) {

        if let sourceViewController = sender.source as? AroioTableConfigViewController, let aroio = sourceViewController.aroio {
            self.navigationController?.navigationBar.barTintColor = self.navBarColor
            if let selectedIndexPath = currentAroio{
                
                aroios[selectedIndexPath.row] = aroio
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                currentAroio = nil
                
            } else {
                
                //Add new Aroio
                let newIndexPath = IndexPath(row: aroios.count , section: 0)
                
                aroios.append(aroio)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            saveAroio()
            
        } else if let _ = sender.source as? MenuViewController, let aroio = AroioObject.aroio {
            self.navigationController?.navigationBar.barTintColor = self.navBarColor
            if let selectedIndexPath = currentAroio{
                
                aroios[selectedIndexPath.row] = aroio
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                currentAroio = nil
                
            }
            AroioObject.aroio?.disconnectFromSocket()
            saveAroio()
            
        }
    }
    
    
    
    //MARK: Private Methods

    private func saveAroio(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(aroios, toFile: Aroio.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Aroios successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Saving Aroios failed...", log: OSLog.default, type: .error)
        }
        
    }
    
    private func loadAroios() -> [Aroio]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Aroio.ArchiveURL.path) as? [Aroio]
    }
    
}


