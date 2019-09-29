//
//  LoginManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import ReactiveSwift

class LoginManager {
    static let shared = LoginManager()
    var sessionId: String = "" {
        didSet {
            UserDefaults.standard.set(sessionId, forKey: sessionKey)
        }
    }
    
    private let sessionKey = "sessionKey"
    
    private init() {
        sessionId = (UserDefaults.standard.value(forKey: sessionKey) as? String) ?? ""
    }
    
    func setup() {
        patientInfoProperty.skipRepeats { return $0?.id == $1?.id }.signal.observeValues { (p) in
            if p == nil {
                RCIM.shared().logout()
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
