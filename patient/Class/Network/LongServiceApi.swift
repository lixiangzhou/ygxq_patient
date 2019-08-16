//
//  LongServiceApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum LongServiceApi: TargetType {
    case privateDocList(pid: Int)
}

extension LongServiceApi {
    var path: String {
        switch self {
        case .privateDocList:
            return "/serlong/getPrivateDoctorList"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .privateDocList(pid: pid):
            params["pageNum"] = 1
            params["pageSize"] = 1000
            params["puid"] = pid
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
