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
    case loginPwd(mobile: String, password: String)
    case getRCToken(userId: String)
    case createRCToken(userId: String)
    case patientInfo(pid: Int)
    case register(mobile: String, password: String, invister: String)
    case updateInfo(params: [String: Any])
    case forgetPwd(mobile: String, password: String)
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
        case .register:
            return "/user/reg"
        case .loginPwd:
            return "/user/login"
        case .updateInfo:
            return "/user/update/information"
        case .forgetPwd:
            return "/user/forgetpwd"
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
        case let .register(mobile: mobile, password: password, invister: invister):
            let data = ["mobile": mobile,
                        "password": password,
                        "usrType": "2",
                        "invister": invister,
                        "termType": "IOS"]
            let dataString = String(data: try! JSONSerialization.data(withJSONObject: data, options: []), encoding: .utf8)!
            params = ["data": dataString,
                      "encrpyt": false]
        case let .loginPwd(mobile: mobile, password: password):
            let data = ["mobile": mobile,
                        "password": password,
                        "usrType": "2",
                        "termType": "IOS"]
            let dataString = String(data: try! JSONSerialization.data(withJSONObject: data, options: []), encoding: .utf8)!
            params = ["data": dataString,
                      "encrpyt": false]
        case let .updateInfo(params: param):
            for (k, v) in param {
                params[k] = v
            }
        case let .forgetPwd(mobile: mobile, password: password):
            let data = ["mobile": mobile,
                        "password": password,
                        "usrType": "2",
                        "termType": "IOS"]
            let dataString = String(data: try! JSONSerialization.data(withJSONObject: data, options: []), encoding: .utf8)!
            params = ["data": dataString,
                      "encrpyt": false]
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
