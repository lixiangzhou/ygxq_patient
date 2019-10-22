//
//  BuglyManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/25.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Bugly

class BuglyManager {
    static let shared = BuglyManager()
    
    func setup() {
        Bugly.start(withAppId: "0c5b33ba95")
    }
}
