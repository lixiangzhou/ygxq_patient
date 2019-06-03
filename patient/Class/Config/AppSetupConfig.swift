//
//  AppSetupConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/31.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct AppSetupConfig {
    static func config() {
        AppearanceConfig.config()
        AppActivityIndicatorConfig.config()
    }
}

