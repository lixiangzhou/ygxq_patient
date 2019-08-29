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
    case queryServices(did: Int)
    case serviceInfo(did: Int, pid: Int, indate: Int)
    case buyPersonalService(duid: Int, puid: Int, serLongId: String,  price: Double, productName: String)
}

extension LongServiceApi {
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
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
