//
//  StringExtension.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

extension String {
    /// 手机号脱敏显示
    var mobileSecrectString: String {
        return count != 11 ? self : zz_replace(start: 3, length: 4, with: "*")
    }
}
