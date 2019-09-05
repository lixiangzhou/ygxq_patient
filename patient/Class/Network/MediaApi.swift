//
//  MediaApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum MediaApi: TargetType {
    case queryById(pid: Int, type: String)
}

extension MediaApi {
    
    var path: String {
        switch self {
        case .queryById:
            return "/serMediaMore/querySerMediasByPuid"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .queryById(pid: pid, type: type):
            params["puid"] = pid
            params["serType"] = type
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}



