//
//  TelApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya 

enum TelApi: TargetType {
    case getLastInfo(pid: Int)
    case addSerConsultTel(params: [String: Any])
    case serConsultTelDetail(tid: Int)
    case queryExamResult(tid: Int)
    case addResources(id: Int, imgs: [String])
}

extension TelApi {
    var path: String {
        switch self {
        case .getLastInfo:
            return "/serconsulttel/getLastInfo"
        case .addSerConsultTel:
            return "/serconsulttel/addSerConsultTel"
        case .serConsultTelDetail:
            return "/serconsulttel/serConsultTelDetail"
        case .queryExamResult:
            return "/serconsulttel/queryExamResult"
        case .addResources:
            return "/serconsulttel/addResources"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .getLastInfo(pid: pid):
            params["puid"] = pid
        case let .addSerConsultTel(params: ps):
            for (k, v) in ps {
                params[k] = v
            }
        case let .serConsultTelDetail(tid: tid):
            params["id"] = tid
        case let .queryExamResult(tid: tid):
            params["id"] = tid
        case let .addResources(id: id, imgs: imgs):
            params["fromWhere"] = 1
            params["id"] = id
            params["imgs"] = imgs
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
