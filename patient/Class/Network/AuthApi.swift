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
    case wxGetToken(code: String)
    case wxGetUserinfo(token: WXOAuthToken)
    case wxRefreshToken
}

extension AuthApi: TargetType {
    var path: String {
        switch self {
        case .getCode:
            return "/auth/code/send"
        case .verifyCode:
            return "/auth/code/verify"
        case .wxGetToken:
            return "/sns/oauth2/access_token"
        case .wxGetUserinfo:
            return "/sns/userinfo"
        case .wxRefreshToken:
            return "/sns/oauth2/refresh_token"
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
        case let .wxGetToken(code: code):
            params = ["appid": WXManager.shared.appId,
                      "secret": WXManager.shared.secret,
                      "code": code,
                      "grant_type": "authorization_code"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case let .wxGetUserinfo(token: token):
            params = ["access_token": token.access_token, "openid": token.openid]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .wxRefreshToken:
            params = ["appid": WXManager.shared.appId, "grant_type": "refresh_token", "refresh_token": WXManager.shared.token!.refresh_token]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    var baseURL: URL {
        switch self {
        case .wxGetUserinfo, .wxGetToken, .wxRefreshToken:
            return URL(string: "https://api.weixin.qq.com")!
        default:
            return NetworkConfig.APP_SERVE_URL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .wxGetToken, .wxGetUserinfo, .wxRefreshToken:
            return .get
        default:
            return .post
        }
    }
}
