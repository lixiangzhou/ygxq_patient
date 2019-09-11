//
//  TaskWorkApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum TaskWorkApi: TargetType {
    case getOrder(pid: Int, linkId: Int, workType: String)
}

extension TaskWorkApi {
    
    var path: String {
        switch self {
        case .getOrder:
            return "/tskwork/getTaskWorkOrder"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .getOrder(pid: pid, linkId: linkId, workType: workType):
            params["puid"] = pid
            params["linkId"] = linkId
            params["workType"] = workType
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}



