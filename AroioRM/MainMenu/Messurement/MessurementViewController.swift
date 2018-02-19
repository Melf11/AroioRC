//
//  MessurementViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import PageMenu

class MessurementViewController: UIViewController, CAPSPageMenuDelegate {
    
    //MARK: Properties
    var pageMenu : CAPSPageMenu?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Messung", image: UIImage(named: "Messurement"), tag: 0)
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.white
        tabBarAppearance.unselectedItemTintColor = lightGrey
        
        let tabBarItemApperance = UITabBarItem.appearance()
        tabBarItemApperance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: lightGrey], for: .normal)
        tabBarItemApperance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Array to keep track of controllers in page menu
        var controllerArray: [UIViewController] = []
        
        let controller0 : UIViewController = UIViewController(nibName: "RoomCorrectionViewController", bundle: nil)
        controller0.title = "Raumkorrektur"
        controllerArray.append(controller0)
        let controller1 : UIViewController = UIViewController(nibName: "GuideViewController", bundle: nil)
        controller1.title = "Tutorial & Erklärungen"
        controllerArray.append(controller1)
        
        
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
        pageMenu!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Delegates for PageMenu
    
    func willMoveToPage(_ controller: UIViewController, index: Int){}
    
    func didMoveToPage(_ controller: UIViewController, index: Int){}
}
