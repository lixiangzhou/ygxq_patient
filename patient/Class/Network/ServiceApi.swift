//
//  ServiceApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum ServiceApi: TargetType {
    case privateDocList(pid: Int)
    case queryServices(did: Int)
    case serviceInfo(did: Int, pid: Int, indate: Int)
    case buyPersonalService(duid: Int, puid: Int, serLongId: String,  price: Double, productName: String)
    case buyVideoConsult(params: [String: Any])
    case isMyPrivateDoctor(did: Int, pid: Int, type: String)
    case createWorkOrder(params: [String: Any])
    case buySunnyDrug(params: [String: Any])
    case querySunshineHutList
    case queryExamResult(id: Int)
}

extension ServiceApi {
    var path: String {
        switch self {
        case .privateDocList:
            return "/serlong/getPrivateDoctorList"
        case .queryServices:
            return "/serlong/querySerLongs"
        case .serviceInfo:
            return "/serlong/querySerLongsDetailInfo"
        case .buyPersonalService:
            return "/serlong/buyPersonalService"
        case .buyVideoConsult:
            return "/serConsultVideo/add"
        case .isMyPrivateDoctor:
            return "/serlong/isMyPrivateDoctor"
        case .createWorkOrder:
            return "/serlong/createWorkOrder"
        case .buySunnyDrug:
            return "/serDrugSunnyBuys/add"
        case .querySunshineHutList:
            return "/sunshineHut/querySunshineHutList"
        case .queryExamResult:
            return "/serConsultVideo/queryExamResult"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .privateDocList(pid: pid):
            params["pageNum"] = 1
            params["pageSize"] = 1000
            params["puid"] = pid
        case let .queryServices(did: did):
            params["duid"] = did
        case let .serviceInfo(did: did, pid: pid, indate: indate):
            params["duid"] = did
            params["indate"] = indate
            params["puid"] = pid
        case let .buyPersonalService(duid: did, puid: pid, serLongId: serLongId, price: price, productName: productName):
            params["duid"] = did
            params["price"] = price
            params["puid"] = pid
            params["serLongId"] = serLongId
            params["productName"] = productName
        case let .buyVideoConsult(params: ps):
            for (k, v) in ps {
                params[k] = v
            }
        case let .isMyPrivateDoctor(did: did, pid: pid, type: type):
            params["duid"] = did
            params["type"] = type
            params["puid"] = pid
        case let .createWorkOrder(params: ps):
            for (k, v) in ps {
                params[k] = v
            }
        case let .buySunnyDrug(params: ps):
            for (k, v) in ps {
                params[k] = v
            }
        case let .queryExamResult(id: id):
            params["id"] = id
        case .querySunshineHutList:
            break
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
