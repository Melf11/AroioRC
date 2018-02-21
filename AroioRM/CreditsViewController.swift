//
//  CreditsViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 02.05.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import SwiftWebVC

class CreditsViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    
    @IBAction func developerButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/Melf11/AroioRC")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func abacusButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://www.abacus-electronics.de")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func informationButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://www.abacus-electronics.de/produkte/streaming/aroioos.html")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func swiftSocketButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/swiftsocket/SwiftSocket")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func pageMenuButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/PageMenu/PageMenu/")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func mcPickerButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/kmcgill88/McPicker-iOS")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func swiftWebVcButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/meismyles/SwiftWebVC")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func bruteFirButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://www.ludd.ltu.se/~torger/brutefir.html")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func gMediaRendererButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/hzeller/gmrender-resurrect")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func lmsButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://en.wikipedia.org/wiki/Logitech_Media_Server")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func shairportButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://github.com/mikebrady/shairport-sync")
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func squeezeButtonPressed(_ sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://code.google.com/archive/p/squeezelite/")
        self.present(webVC, animated: true, completion: nil)
    }
}
