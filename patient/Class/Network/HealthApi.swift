//
//  HealthApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/8.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum HealthApi: TargetType {
    case queryHealthLogs(pid: Int)
}

extension HealthApi {
    var path: String {
        switch self {
        case .queryHealthLogs:
            return "/health/log/queryHealthLogs"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .queryHealthLogs(pid: pid):
            params["puid"] = pid
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
