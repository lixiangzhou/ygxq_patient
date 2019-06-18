//
//  BasicExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toTime(format: String) -> String {
        return date.zz_string(withDateFormat: format)
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
}
