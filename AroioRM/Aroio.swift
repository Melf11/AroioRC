//
//  Aroio.swift
//  AroioRM
//
//  Created by Melf Stöcken on 02.05.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import os.log
import SwiftSocket

//Global Aroio object for the whole menu
struct AroioObject {
    static var aroio: Aroio?
}

class Aroio: NSObject, NSCoding {

    

    //MARK: Properties
    var hostName: String
    var ipAddr: String
    var playerName: String?
    var client: TCPClient

    //MARK: Types
    struct PropertyKey {
        
        static let hostName = "hostName"
        static let ipAddr = "ipAddr"
        static let playerName = "playerName"
        
    }
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("aroios")
    
    
    //MARK: Initialization
    init?(hostName: String, ipAddr: String, playerName: String) {
        
       
        //  guard !hostName.isEmpty else {return nil}
        //  guard ipAddr.isEmpty else {return nil}
        
        self.hostName = hostName
        self.ipAddr = ipAddr
        self.playerName = playerName
        self.client = TCPClient(address: "\(self.hostName)", port: 4444)
   
    }
    
    //MARK: Socket Connection Functions
    // Implements the Connection to AroioOS via Swift Socket
    func connectToSocket() -> Bool{
        
        print("Hostname: \(self.hostName)")

        // connect to client with hostname, if it fails, try to connect with ip
        switch client.connect(timeout: 1) {
        case .success:

            return true
            
        case .failure(let error):
         
            self.client = TCPClient(address: "\(self.ipAddr)", port: 4444)
            os_log("Failed to connect with hostname, try ip", log: OSLog.default, type: .debug)
            
            switch client.connect(timeout: 1) {
            case .success:
               
                return true
                
            case .failure(let error):
               print(error)
                return false
            }
        }
        
    }
    
    // sending a request to aroio socketserver and returns userconfig.txt parameter as string.
    // Request form is a string: "response;REQUEST;default\n"
    // "response" is to define the action for the server
    // "default" has to be the third value because the server is expecting 3 values
    // \n has to be at the end to seperate the different requests
    
    func getUserconfigParameter(request: String) -> String{

        let response = "response;\(request);default;\n"
        let data: Data = response.data(using: String.Encoding.utf8)!
        switch client.send(data: data) {
        case .success:
            os_log("Send 'respose' successful, receive answer", log: OSLog.default, type: .debug)
            
            if let data = client.read(128*1, timeout: 1){
                if let answer = String(bytes: data, encoding: .utf8) {
                    
                    if (answer == "\n"){
                        return ""
                    } else {
                        return answer
                    }
                    
                    return answer
                }
            }
        case .failure(let error):
            os_log("Could not send 'request' to server.", log: OSLog.default, type: .error)
            print("Error: \(error)")
        }
        
        return ""
    }
    
    // sending a request to aroio socketserver to change a parameter in userconfig.txt on AroioOS
    // Request forn is a string: "change;PARAMETER;newValue\n"
    // "change" is to define the action for the server
    // newValue is the new parameter
    // \n has to be at the end to seperate the different requests
    func sendRequestToSocket(request: String, newValue: String){

        let response = "change;\(request);\(newValue);\n"
        let data = response.data(using: String.Encoding.utf8)!
        
        switch client.send(data: data) {
        case .success:
            os_log("Send 'change' successful and switch", log: OSLog.default, type: .debug)

        case .failure(let error):
            os_log("Could not send 'request' to server.", log: OSLog.default, type: .error)
            print(error)
        }
        
    }

    func disconnectFromSocket(){
        client.close()
        os_log("Socket Client successfully closed.", log: OSLog.default, type: .debug)
    }
    
    
    
    //MARK: NSCoding
    
    //TODO: have to encode and decode the ip array!

    func encode(with aCoder: NSCoder){
        aCoder.encode(hostName, forKey: PropertyKey.hostName)
        aCoder.encode(ipAddr, forKey: PropertyKey.ipAddr)
        aCoder.encode(playerName, forKey: PropertyKey.playerName)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        
        guard let hostName = aDecoder.decodeObject(forKey: PropertyKey.hostName) as? String
            else {
                os_log("Unable to decode the Hostname for a Aroio objekt.", log: OSLog.default, type: .debug)
                return nil
        }

        let ipAddr = aDecoder.decodeObject(forKey: PropertyKey.ipAddr) as! String

        guard let playerName = aDecoder.decodeObject(forKey: PropertyKey.playerName) as? String
            else {
                os_log("Unable to decode the Playername for a Aroio objekt.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Must call designated initializer.
        self.init(hostName: hostName, ipAddr: ipAddr, playerName: playerName)
    }


    
    
}
