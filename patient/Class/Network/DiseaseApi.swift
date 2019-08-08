//
//  DiseaseApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum DiseaseApi: TargetType {
    case diseasetypes
}

extension DiseaseApi {
    var path: String {
        switch self {
        case .diseasetypes:
            return "/disease/list/diseasetypes"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case .diseasetypes:
            break
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
