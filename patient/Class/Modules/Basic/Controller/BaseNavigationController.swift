//
//  BaseNavigationController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetNavBarFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetNavBarFrame()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        resetNavBarFrame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        resetNavBarFrame()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = viewControllers.count > 0
        print("PUSH => \(viewController.classForCoder)")
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        let string = vc?.classForCoder != nil ? "\(vc!.classForCoder)" : "NONE"
        print("POP => \(string)")
        return vc
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController!.supportedInterfaceOrientations
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController!.preferredStatusBarStyle
    }

    override var shouldAutorotate: Bool {
        return topViewController!.shouldAutorotate
    }

    override var prefersStatusBarHidden: Bool {
        return topViewController!.prefersStatusBarHidden
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}

extension BaseNavigationController {
    private func resetNavBarFrame() {
        for sub in navigationBar.subviews {
            if sub.zz_className == "_UIBarBackground" {
                sub.frame = CGRect(x: 0, y: -UIScreen.zz_nav_statusHeight, width: UIScreen.zz_width, height: UIScreen.zz_navHeight)
                if !sub.subviews.isEmpty {
                    for s in sub.subviews {
                        if s.frame.height > 1 {
                            s.frame = sub.bounds
                        } else {
                            s.frame = CGRect(x: 0, y: UIScreen.zz_navHeight, width: UIScreen.zz_width, height: 1.0 / 3.0)
                        }
                    }
                }
            }
        }
    }
}
