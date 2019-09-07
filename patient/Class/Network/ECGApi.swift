//
//  ECGApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum ECGApi: TargetType {
    case isBuyECG(pid: Int, keyword: String)
}

extension ECGApi {
    
    var path: String {
        switch self {
        case .isBuyECG:
            return "/ecg12/isBuyECG"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .isBuyECG(pid: pid, keyword: keyword):
            params["puid"] = pid
            params["keyWord"] = keyword
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}



