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
    case orders(pid: Int, state: SunnyDrugOrderState)
    case orderInfo(id: Int)
}

extension DrugSunApi {
    var path: String {
        switch self {
        case .usedDrugs:
            return "/serDrugSunnyBuys/querySerDrugUesd"
        case .orders:
            return "/serDrugSunnyBuys/listByPuid"
        case .orderInfo:
            return "/serDrugSunnyBuys/getOrderInfo"
        default:
            break
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .usedDrugs(pid: pid):
            params["puid"] = pid
        case let .orders(pid: pid, state: state):
            params["puid"] = pid
            params["serStatus"] = state.rawValue
        case let .orderInfo(id: id):
            params["id"] = id
        default:
            break
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
