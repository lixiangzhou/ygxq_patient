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
}

extension DoctorApi {
    var path: String {
        switch self {
        case .doctorInfo:
            return "/doctor/info"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .doctorInfo(duid: id):
            params["duid"] = id
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
