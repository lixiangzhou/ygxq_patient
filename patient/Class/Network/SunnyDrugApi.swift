//
//  SunnyDrugApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum SunnyDrugApi: TargetType {
    case usedDrugs(pid: Int)
    case orders(pid: Int, state: SunnyDrugOrderState)
    case orderInfo(id: Int)
    case queryExamResult(id: Int)
    case addResources(pid: Int, id: Int, imgs: [String])
}

extension SunnyDrugApi {
    var path: String {
        switch self {
        case .usedDrugs:
            return "/serDrugSunnyBuys/querySerDrugUesd"
        case .orders:
            return "/serDrugSunnyBuys/listByPuid"
        case .orderInfo:
            return "/serDrugSunnyBuys/getOrderInfo"
        case .queryExamResult:
            return "/serDrugSunnyBuys/queryExamResult"
        case .addResources:
            return "/serDrugSunnyBuys/addResources"
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
        case let .queryExamResult(id: id):
            params["id"] = id
        case let .addResources(pid: pid, id: id, imgs: imgs):
            params["fromWhere"] = 1
            params["id"] = id
            params["imgs"] = imgs
//            params["puid"] = pid
        default:
            break
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
