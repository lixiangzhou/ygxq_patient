//
//  FLPApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum FLPApi: TargetType {
    case queryFlpDetails(pid: Int)
    case queryFlpExams(id: Int)
}

extension FLPApi {
    var path: String {
        switch self {
        case .queryFlpDetails:
            return "/flp/queryFlpDetails"
        case .queryFlpExams:
            return "/flp/queryFlpExams"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .queryFlpDetails(pid: pid):
            params["puid"] = pid
        case let .queryFlpExams(id: id):
            params["id"] = id
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
