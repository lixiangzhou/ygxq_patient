//
//  DoctorApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum DoctorApi: TargetType {
    case doctorInfo(duid: Int)
    case assist(duid: Int)
    case serList(duid: Int, puid: Int)
}

extension DoctorApi {
    var path: String {
        switch self {
        case .doctorInfo:
            return "/doctor/info"
        case .assist:
            return "/doctor/queryAssistantByDuid"
        case .serList:
            return "/doctor/doctorSerManageList"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .doctorInfo(duid: did):
            params["duid"] = did
        case let .assist(duid: did):
            params["duid"] = did
        case let .serList(duid: did, puid: pid):
            params["id"] = did
            params["puid"] = pid
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
