//
//  LoginManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/// 登录状态 信号量
let (_loginSignal, loginObserver) = Signal<Bool, NoError>.pipe()
let loginSignal = _loginSignal.skipRepeats()

class LoginManager {
    static let shared = LoginManager()
    private init() { }
    
    func setup() {
        loginSignal.observeValues { isLogin in
            if !isLogin {
                guard let rootVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController,
                    let nav = rootVC.selectedViewController as? BaseNavigationController else { return }
                rootVC.present(BaseNavigationController(rootViewController: LoginController()), animated: true) {
                    nav.popToRootViewController(animated: true)
                    rootVC.selectedIndex = 0
                }
            }
        }
    }
}
