//
//  PayApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum PayApi: TargetType {
    case wxPayInfo(tradeNo: String)
}

extension PayApi {
    var baseURL: URL {
        switch self {
        case .wxPayInfo:
            return NetworkConfig.APP_PAY_URL
        }
    }
    
    var path: String {
        switch self {
        case .wxPayInfo:
            return "/wechat/appPayInfo"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .wxPayInfo(tradeNo: tradeNo):
            params["out_trade_no"] = tradeNo
            params["trade_type"] = "APP"
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}


