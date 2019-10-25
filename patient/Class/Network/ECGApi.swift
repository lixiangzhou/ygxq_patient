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
    case list7Ago(pid: Int, time: TimeInterval)
    case getLastOneByDate(pid: Int, time: TimeInterval?)
    case querySurpluNum(pid: Int)
    case queryEcg12List(pid: Int)
    case addECG(params: [String: Any])
}

extension ECGApi {
    
    var path: String {
        switch self {
        case .isBuyECG:
            return "/ecg12/isBuyECG"
        case .list7Ago:
            return "/ecg12/list7Ago"
        case .getLastOneByDate:
            return "/ecg12/getLastOneByDate"
        case .querySurpluNum:
            return "/ecg12/querySurpluNum"
        case .queryEcg12List:
            return "/ecg12/queryEcg12List"
        case .addECG:
            return "/ecg12/addECG"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .isBuyECG(pid: pid, keyword: keyword):
            params["puid"] = pid
            params["keyWord"] = keyword
        case let .list7Ago(pid: pid, time: time):
            params["puid"] = pid
            params["createTime"] = time
        case let .getLastOneByDate(pid: pid, time: time):
            params["puid"] = pid
            if let time = time {
                params["createTime"] = time
            }
        case let .querySurpluNum(pid: pid):
            params["puid"] = pid
        case let .queryEcg12List(pid: pid):
            params["puid"] = pid
        case let .addECG(params: ps):
            for (k, v) in ps {
                params[k] = v
            }
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}



