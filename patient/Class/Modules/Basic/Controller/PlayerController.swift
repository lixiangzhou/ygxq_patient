//
//  PlayerController.swift
//  patient
//
//  Created by lixiangzhou on 2019/11/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PlayerController: BaseController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ZZPlayerView.shared.config.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return ZZPlayerView.shared.config.statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ZZPlayerView.shared.reset()
    }
}

// MARK: - UI
extension PlayerController {
    override func setUI() {
        hideNavigation = true
        
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let vm = VideoModel(title: "测试标题", videoUrlString: "http://video.699pic.com/videos/05/50/48/a_pneBEn5HmF381571055048.mp4")
                
        ZZPlayerView.shared.configHorizontal.statusBarStyle = .lightContent
        if UIDevice.current.zz_isIPhoneX_Series {
            ZZPlayerView.shared.configHorizontal.top.height = 40
        } else {
            ZZPlayerView.shared.configHorizontal.top.height = 60
            ZZPlayerView.shared.configHorizontal.top.icon.offsetY = 10
            ZZPlayerView.shared.configHorizontal.top.title.offsetY = 10
        }
        
        ZZPlayerView.shared.configHorizontal.top.icon.size = CGSize(width: 50, height: 40)
        ZZPlayerView.shared.configHorizontal.top.icon.rightPadding = 0
        ZZPlayerView.shared.configHorizontal.statusBarShowMode = .showHide
        ZZPlayerView.shared.configHorizontal.bottom.playPause.size = CGSize(width: 40, height: 40)
        ZZPlayerView.shared.configHorizontal.bottom.playPause.rightPadding = 0
        ZZPlayerView.shared.configHorizontal.bottom.startTime.leftPadding = -10
        ZZPlayerView.shared.configHorizontal.bottom.fullScreen.size = CGSize(width: 40, height: 40)
        ZZPlayerView.shared.configHorizontal.bottom.playPause.leftPadding = 5
        ZZPlayerView.shared.configHorizontal.bottom.playPause.leftPadding = 5
        
        ZZPlayerView.shared.orientationMode = .landscapeLeft
        ZZPlayerView.shared.configHorizontal.autoPlay = true
        
        DispatchQueue.main.async {
            UIApplication.shared.statusBarOrientation = .landscapeRight
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        ZZPlayerView.shared.backAction = { [weak self] in
            self?.pop()
        }
        
        ZZPlayerView.shared.playerItemResource = vm
        
        view.addSubview(ZZPlayerView.shared)
        
        ZZPlayerView.shared.fullscreen()
    }
}

// MARK: - Delegate External


// MARK: - Helper
extension PlayerController {
    
}

class VideoModel: NSObject, ZZPlayerItemResource {
    var placeholderImage: UIImage?
    var placeholderImageUrl: String?
    var title: String
    var videoUrlString: String
    var seekTo: TimeInterval = 0
    
    init(title: String, videoUrlString: String) {
        self.title = title
        self.videoUrlString = videoUrlString
    }
}


