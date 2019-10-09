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
    case queryHealthLogList(pid: Int, type: String, time: TimeInterval)
    case addLog(params: [String: Any])
}

extension HealthApi {
    var path: String {
        switch self {
        case .queryHealthLogs:
            return "/health/log/queryHealthLogs"
        case .queryHealthLogList:
            return "/health/log/queryHealthLogList"
        case .addLog:
            return "/health/log/add"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .queryHealthLogs(pid: pid):
            params["puid"] = pid
        case let .queryHealthLogList(pid: pid, type: type, time: time):
            params["createTime"] = time
            params["healthLogType"] = type
            params["puid"] = pid
        case let .addLog(params: ps):
            for (k, v) in ps {
                params[k] = v
            }
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
