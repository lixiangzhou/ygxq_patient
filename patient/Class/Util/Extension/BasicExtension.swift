//
//  BasicExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toTime(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        return date.zz_string(withDateFormat: format)
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: self / 1000)
    }
}

extension Double {
    var bottomPayPriceString: NSAttributedString {
        let attrString = NSMutableAttributedString(string: "￥", attributes: [NSAttributedString.Key.font: UIFont.boldSize(14)])
        
        let priceString = String(format: "%.2f", self)
        if let idx = priceString.firstIndex(of: ".") {
            attrString.append(NSAttributedString(string: "\(priceString[..<idx])", attributes: [NSAttributedString.Key.font: UIFont.boldSize(17)]))
            attrString.append(NSAttributedString(string: "\(priceString[idx...])", attributes: [NSAttributedString.Key.font: UIFont.boldSize(14)]))
        } else {
            attrString.append(NSAttributedString(string: priceString, attributes: [NSAttributedString.Key.font: UIFont.boldSize(17)]))
        }
        
        return attrString
    }
    
    func priceString(prefixFont: UIFont, bigPriceFont: UIFont, smallPriceFont: UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "￥", attributes: [NSAttributedString.Key.font: prefixFont])
        
        let priceString = String(format: "%.2f", self)
        if let idx = priceString.firstIndex(of: ".") {
            attrString.append(NSAttributedString(string: "\(priceString[..<idx])", attributes: [NSAttributedString.Key.font: bigPriceFont]))
            attrString.append(NSAttributedString(string: "\(priceString[idx...])", attributes: [NSAttributedString.Key.font: smallPriceFont]))
        } else {
            attrString.append(NSAttributedString(string: priceString, attributes: [NSAttributedString.Key.font: bigPriceFont]))
        }
        
        return attrString
    }
}

func getAge(_ birth: TimeInterval?) -> Int? {
    if let birth = birth {
        let birthDate = Date(timeIntervalSince1970: birth / 1000)
        let date = Date()
        
        var age = date.zz_year - birthDate.zz_year
        if (birthDate.zz_month > date.zz_month) || (birthDate.zz_month == date.zz_month && birthDate.zz_day > date.zz_day) {
            age -= 1
        }
        return age
    } else {
        return nil
    }
}

extension Collection where Iterator.Element: ModelProtocol {
    
    func tojson() -> [[String: Any]?] {
        return self.map{ $0.toJSON() }
    }
    
    func tojsonString(prettyPrint: Bool = false) -> String? {
        
        let anyArray = self.toJSON()
        if JSONSerialization.isValidJSONObject(anyArray) {
            do {
                let jsonData: Data
                if prettyPrint {
                    jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [.prettyPrinted])
                } else {
                    jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
                }
                return String(data: jsonData, encoding: .utf8)
            } catch {
                
            }
        } else {
            
        }
        return nil
    }
}



