//
//  AppearanceConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/31.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct AppearanceConfig {
    static func config() {
        setNavAppearance()
        setTabAppearance()
    }
    
    static func setNavAppearance() {
        UINavigationBar.appearance().tintColor = .cf
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSize(18), NSAttributedString.Key.foregroundColor: UIColor.cf]
    }
    
    static func setTabAppearance() {
        UITabBar.appearance().tintColor = .c407cec
        UITabBar.appearance().backgroundColor = .cf
    }
}
