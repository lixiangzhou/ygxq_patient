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
    
    /// 身份证号脱敏显示
    var idSecrectString: String {
        if count == 15 {
            return zz_replace(start: 8, length: 4, with: "*")
        } else if count == 18 {
            return zz_replace(start: 10, length: 4, with: "*")
        }
        return count != 11 ? self : zz_replace(start: 3, length: 4, with: "*")
    }
    
    func needed(with font: UIFont, color: UIColor) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        attributeString.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.cf25555]))
        return attributeString
    }
}
