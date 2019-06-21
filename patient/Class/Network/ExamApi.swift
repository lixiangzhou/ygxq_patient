//
//  ExamApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum ExamApi: TargetType {
    case examList(pid: Int)
}

extension ExamApi {
    var path: String {
        switch self {
        case .examList:
            return "/exam/queryExamsByPuid"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .examList(pid: pid):
            params["puid"] = pid
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
