//
//  AuthApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum AuthApi {
    enum CodeType: Int {
        case forLogin = 3
        case forModifyPwd = 2
        case forRegister = 1
    }
    
    case getCode(type: CodeType, mobile: String)
    case verifyCode(mobile: String, code: String)
}

extension AuthApi: TargetType {
    var path: String {
        switch self {
        case .getCode:
            return "/auth/code/send"
        case .verifyCode:
            return "/auth/code/verify"
        default:
            return ""
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .getCode(type: type, mobile: mobile):
            let data: [String: Any] = ["mobile": mobile,
                                       "smsType": type.rawValue,
                                       "usrType": "2",
                                       "termType": "IOS"]
            let dataString = String(data: try! JSONSerialization.data(withJSONObject: data, options: []), encoding: .utf8)!
            params = ["data": dataString,
                      "encrpyt": false]
        case let .verifyCode(mobile: mobile, code: code):
            params = ["mobile" : mobile,
                      "code" : code,
                      "usrType" : "2",
                      "termType" : "IOS"]
        default:
            break
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}

