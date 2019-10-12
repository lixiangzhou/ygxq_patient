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
    case list7Ago(pid: Int)
    case getLastOneByDate(pid: Int, time: TimeInterval)
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
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .isBuyECG(pid: pid, keyword: keyword):
            params["puid"] = pid
            params["keyWord"] = keyword
        case let .list7Ago(pid: pid):
            params["puid"] = pid
        case let .getLastOneByDate(pid: pid, time: time):
            params["puid"] = pid
            params["createTime"] = time
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}



