//
//  GuideViewController.swift
//  AroioRM
//
//  Created by Melf Stöcken on 12.07.17.
//  Copyright © 2017 ABACUS electronics. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import youtube_ios_player_helper

class GuideView: UIView {

    //TODO: Implement messurement Guide somehow
    
    
    //MARK: Properties
    
    @IBOutlet weak var videoView: UIWebView!
    let ytPlayerView = YTPlayerView()
    
    override func awakeFromNib() {
       // ytPlayerView.load(withVideoId: "XmE-weP9M78");
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

class GuideViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        videoView.allowsInlineMediaPlayback = true
        videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"https://www.youtube.com/embed/0gdUvWumfpk?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        */
    }
}
