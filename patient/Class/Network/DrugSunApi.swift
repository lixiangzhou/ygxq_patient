//
//  DrugSunApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum DrugSunApi: TargetType {
    case usedDrugs(pid: Int)
}

extension DrugSunApi {
    var path: String {
        switch self {
        case .usedDrugs:
            return "/serDrugSunnyBuys/querySerDrugUesd"
        default:
            break
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .usedDrugs(pid: pid):
            params["puid"] = pid
        default:
            break
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
