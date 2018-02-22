//
//  AddAroioViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 02.05.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import os.log

extension NSData {
    func castToCPointer<T>() -> T {
        let mem = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T.Type>.size)
        self.getBytes(mem, length: MemoryLayout<T.Type>.size)
        return mem.move()
    }
}

class AroioTableConfigViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NetServiceDelegate, NetServiceBrowserDelegate {

    //MARK: Properties
    
    //serviceType is still the same from AirPlay Devices, has to change with an aroioOS Update
    let serviceType: String = "_raop._tcp"
    let serviceDomain: String = ""
    
    
    var browser: NetServiceBrowser!
    var bonjourServices = [NetService]()
    var ipAddresses: [String] = []
    
    // IndexPath of current used Aroio
    private var currentAroio: IndexPath?
    let cellIdentifier = "BonjourTableViewCell"

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var hostnameTextField: UITextField!

    @IBOutlet weak var ipAddrLabel: UILabel!
    
    @IBOutlet weak var ip0TextField: UITextField!
    @IBOutlet weak var ip1TextField: UITextField!
    @IBOutlet weak var ip2TextField: UITextField!
    @IBOutlet weak var ip3TextField: UITextField!
    
    @IBOutlet weak var bonjourTableView: UITableView!
    /*
     This value is either passed by `AroioTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new aroio.
     */
    
    var aroio: Aroio?

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.bonjourServices.removeAll()
        self.browser = NetServiceBrowser()
        self.browser.delegate = self
        self.browser.searchForServices(ofType:serviceType, inDomain: serviceDomain)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AroioTableConfigViewController.tapBonjourTableViewCell(_:)))
        bonjourTableView.addGestureRecognizer(tapRecognizer)
        bonjourTableView.delegate = self
        bonjourTableView.dataSource = self

        ip0TextField.delegate = self
        ip0TextField.keyboardType = .numberPad
        ip0TextField.returnKeyType = .next
        ip0TextField.tag = 0
        
        ip1TextField.delegate = self
        ip1TextField.keyboardType = .numberPad
        ip1TextField.returnKeyType = .next
        ip1TextField.tag = 1
        
        ip2TextField.delegate = self
        ip2TextField.keyboardType = .numberPad
        ip2TextField.returnKeyType = .next
        ip2TextField.tag = 2
        
        ip3TextField.delegate = self
        ip3TextField.keyboardType = .numberPad
        ip3TextField.returnKeyType = .done
        ip3TextField.tag = 3
        
        // setup views if editing an existing meal
        if let aroio = aroio {
            navigationItem.title    = aroio.hostName
            hostnameTextField.text  = aroio.hostName
            
            let ipArray = aroio.ipAddr.components(separatedBy: ".")
            
            ip0TextField.text = ipArray[0]
            ip1TextField.text = ipArray[1]
            ip2TextField.text = ipArray[2]
            ip3TextField.text = ipArray[3]
            
        }

       updateSaveButtonState()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: TableView for Aroio searching
    // All methods for tableView as well

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = bonjourTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BonjourTableViewCell else {
            fatalError("The dequeued cell is not an instance of AroioTableViewCell")
        }
        
        
        let service = self.bonjourServices[indexPath.row]
        
        cell.contentView.isUserInteractionEnabled = false;
        
        let serviceName = service.hostName
        if let name = serviceName?.components(separatedBy: ".").first {
            cell.hostNameLabel?.text = name
        }
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonjourServices.count
    }
    
    
    //MARK: BonjourDiscovery
    func updateInterface () {
        for service in self.bonjourServices {
            service.delegate = self
            service.resolve(withTimeout:10.0)
        }
    }
    
    @objc func netServiceDidResolveAddress(_ sender: NetService) -> String{
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        guard let data = sender.addresses?.first else { return ""}
        do {
            try data.withUnsafeBytes { (pointer:UnsafePointer<sockaddr>) -> Void in
                guard getnameinfo(pointer, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    throw NSError(domain: "domain", code: 0, userInfo: ["error":"unable to get ip address"])
                }
            }
        } catch {
            print(error)
            return ""
        }
        return String(cString:hostname)
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didFind aNetService: NetService, moreComing: Bool) {
        self.bonjourServices.append(aNetService)
        if !moreComing {
            self.updateInterface()
        }
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didRemove aNetService: NetService, moreComing: Bool) {
        if let ix = self.bonjourServices.index(of:aNetService) {
            self.bonjourServices.remove(at:ix)
            if !moreComing {
                self.updateInterface()
            }
        }
    }
    
    //MARK: Actions
 
    //TODO: Make "Finde Aroio" Button usefull because it's just browsing for netserviceses by entering this VC and not doing a new discovery by pressing the button

    @IBAction func detectNetwork(_ sender: UIButton) {
        print("listening for services...")
        
        // self.bonjourServices.removeAll()
        // self.browser.searchForServices(ofType:serviceType, inDomain: serviceDomain)
        
        //sleep(1)
        bonjourTableView.reloadData()
    }
    
    @IBAction func tapBonjourTableViewCell(_ sender: UITapGestureRecognizer) {
        os_log("tap(_:) used!", log: OSLog.default, type: .debug)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: bonjourTableView)
            os_log("sender", log: OSLog.default, type: .debug)
            
            if let indexPath = bonjourTableView.indexPathForRow(at: touchPoint) {
                
                os_log("indexPath", log: OSLog.default, type: .debug)
                
                putDataIntoTextFields(self.bonjourServices[indexPath.row])
               // os_log("Put \(self.bonjourServices[indexPath.row].name) into TextFields", log: OSLog.default, type: .debug)
                
            } else {
                 os_log("Could not tap BonjourTable", log: OSLog.default, type: .debug)
            }
        }
    }
    
    func putDataIntoTextFields(_ sender: NetService){
        
        os_log("putDataIntoTextFields get called", log: OSLog.default, type: .debug)
        
        if let name = sender.hostName?.components(separatedBy: ".").first{
            
            //let ip = getIpFromSocket(hostname: name)
            
            self.hostnameTextField.text = name
            
            let ipString = netServiceDidResolveAddress(sender)
            let ipArray = ipString.components(separatedBy: ".")
            
            self.ip0TextField.text = ipArray[0]
            self.ip1TextField.text = ipArray[1]
            self.ip2TextField.text = ipArray[2]
            self.ip3TextField.text = ipArray[3]
        }
    }
    
    //MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        if presentingViewController is AroioTableViewController {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ConfigurationAroioViewController is not inside a navigation controller.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
        return
        }
        
        let hostname = hostnameTextField.text ?? ""
        
        let ip: String = "\(Int(ip0TextField.text!)!).\(Int(ip1TextField.text!)!).\(Int(ip2TextField.text!)!).\(Int(ip3TextField.text!)!)"
        let playername = hostnameTextField.text ?? ""
        
        aroio = Aroio(hostName: hostname, ipAddr: ip, playerName: playername)
 
    }

    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = hostnameTextField.text
    }
    

    //TODO: make ipTextFields only accepting 3 numbers
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "") 
        return string == filtered
    }
    
    
    
    //MARK: Private Mathods
    
    private func updateSaveButtonState(){
        let text = hostnameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
  
}

 
