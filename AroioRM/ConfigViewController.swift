//
//  ConfigViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import PageMenu

class ConfigViewController: UIViewController{

    //MARK: Properties
    var pageMenu : CAPSPageMenu?

    override func viewWillAppear(_ animated: Bool) {
        tabBarItem = UITabBarItem(title: "Konfiguration", image: UIImage(named: "Config"), tag: 0)
        let tabBarItemApperance = UITabBarItem.appearance()
        tabBarItemApperance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: lightGrey], for: .normal)
        tabBarItemApperance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
        // Array to keep track of controllers in page menu
        var controllerArray: [UIViewController] = []
        
        // adding VC to pageMenu
        let controller0 : UIViewController = UIViewController(nibName: "AudioViewController", bundle: nil)
        controller0.title = "Audio"
        controllerArray.append(controller0)
        let controller1 : UIViewController = UIViewController(nibName: "NetworkViewController", bundle: nil)
        controller1.title = "Netzwerk"
        controllerArray.append(controller1)
        let controller2 : UIViewController = UIViewController(nibName: "PlayerViewController", bundle: nil)
        controller2.title = "Player"
        controllerArray.append(controller2)
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(lightBlue),
            .useMenuLikeSegmentedControl(true),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 17.0)!),
            .selectionIndicatorColor(UIColor.white),
            .unselectedMenuItemLabelColor(lightGrey),
            ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0,y: 0.0,width: self.view.frame.width,height: self.view.frame.height), pageMenuOptions: parameters)
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Delegate Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
