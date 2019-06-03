//
//  AppActivityIndicatorConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/31.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

struct AppActivityIndicatorConfig {
    static let requestCount = MutableProperty(0)
    static func config() {
        UIApplication.shared.reactive.makeBindingTarget { $0.isNetworkActivityIndicatorVisible = $1 } <~ requestCount.signal.map { $0 > 0 }
    }
}
