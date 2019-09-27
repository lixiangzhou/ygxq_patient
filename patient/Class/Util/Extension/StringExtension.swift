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
    
    var isChinese: Bool {
        let regex = "[\\u4e00-\\u9fa5]+"
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self.zz_ns)
    }
    
    var isEnglish: Bool {
        let regex = "[a-zA-Z]*"
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self.zz_ns)
    }
    
    /// 是否符合姓名输入要求
    var isMatchNameInputValidate: Bool {
        let regex = "[\\u4e00-\\u9fa5a-zA-Z·➋➌➍➎➏➐➑➒]*"
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self.zz_ns)
    }
    
    /// 是否匹配身份证号
    var isMatchIdNo: Bool {
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self.zz_ns)
    }
}
