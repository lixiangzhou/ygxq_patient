//
//  HLRApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum HLRApi: TargetType {
    case caseRecordList(pid: Int, type: Int)
    case checkList(pid: Int, type: Int)
    case caseRecord(id: Int)
    case checkRecord(id: Int)
}

extension HLRApi {
    var path: String {
        switch self {
        case .caseRecordList:
            return "/hlrMore/listCaseRecordList"
        case .checkList:
            return "/hlrMore/listChecklist"
        case .caseRecord:
            return "/hlrMore/getCaseRecord"
        case .checkRecord:
            return "/hlrMore/getChecklist"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .caseRecordList(pid: pid, type: type):
            params["puid"] = pid
            params["type"] = type
        case let .checkList(pid: pid, type: type):
            params["puid"] = pid
            params["type"] = type
        case let .caseRecord(id: id):
            params["id"] = id
        case let .checkRecord(id: id):
            params["id"] = id
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
