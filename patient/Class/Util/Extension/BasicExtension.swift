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
            } catch let error {
                
            }
        } else {
            
        }
        return nil
    }
}



