//
//  BaseTabBarController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (selectedViewController as? BaseNavigationController)?.topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (selectedViewController as? BaseNavigationController)?.topViewController?.preferredStatusBarStyle ?? .default
    }

    override var shouldAutorotate: Bool {
        return (selectedViewController as? BaseNavigationController)?.topViewController?.shouldAutorotate ?? false
    }

    override var prefersStatusBarHidden: Bool {
        return (selectedViewController as? BaseNavigationController)?.topViewController?.prefersStatusBarHidden ?? false
    }
}
