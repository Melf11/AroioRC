//
//  RoomCorrectionViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit

class RoomCorrectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //   commonInit()
    }
    @IBAction func runMessurement(_ sender: UIButton) {
        AroioObject.aroio?.getUserconfigValue(value: "STARTMESSUREMENT")
    }
    @IBAction func stopMessurement(_ sender: UIButton) {
        AroioObject.aroio?.getUserconfigValue(value: "CANCELMESSUREMENT")
    }
}

class RoomCorrectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
