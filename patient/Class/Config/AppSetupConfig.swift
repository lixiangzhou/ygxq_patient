//
//  AppSetupConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/31.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

let appService = "阳光客户端服务协议"

struct AppSetupConfig {
    static func config() {
        AppearanceConfig.config()
        AppActivityIndicatorConfig.config()
        WXManager.shared.setup()
        RCManager.shared.setup()
        LoginManager.shared.setup()
    }
}

