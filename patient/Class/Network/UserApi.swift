//
//  UserApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum UserApi {
    case login(mobile: String, password: String)
    case register
}

extension UserApi: TargetType {
    var path: String {
        switch self {
        case .login:
            return "/user/login"
        default:
            return ""
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .login(mobile: mobile, password: password):
            params["data"] = ["mobile" : mobile,
                              "password" : password,
                              "usrType" : "2",
                              "token"   : "",
                              "termType" : "IOS"]
            params["encrpyt"] = false
        default:
            break
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
