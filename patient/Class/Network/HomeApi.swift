//
//  HomeApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum HomeApi: TargetType {
    case bannerList
}

extension HomeApi {
    var path: String {
        switch self {
        case .bannerList:
            return "/homepage/getCmnBannerlist"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case .bannerList: break
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
