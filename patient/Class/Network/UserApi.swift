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
    case loginCode(mobile: String, code: String)
    case getRCToken(userId: String)
    case createRCToken(userId: String)
    case patientInfo(pid: Int)
}

extension UserApi: TargetType {
    var path: String {
        switch self {
        case .loginCode:
            return "/auth/code/login"
        case .getRCToken:
            return "/user/getRCToken"
        case .createRCToken:
            return "/user/createRCToken"
        case .patientInfo:
            return "/user/patient/information"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .loginCode(mobile: mobile, code: code):
            let data = ["mobile": mobile,
                        "code": code,
                        "usrType": "2",
                        "termType": "IOS"]
            let dataString = String(data: try! JSONSerialization.data(withJSONObject: data, options: []), encoding: .utf8)!
            params = ["data": dataString,
                      "encrpyt": false]
            params["encrpyt"] = false
        case let .getRCToken(userId: id):
            params["id"] = id
        case let .createRCToken(userId: id):
            params["id"] = id
        case let .patientInfo(pid: id):
            params["id"] = id
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
