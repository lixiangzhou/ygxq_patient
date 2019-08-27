//
//  ConsultApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum ConsultApi: TargetType {
    case consultList(isFinished: Bool, puid: Int)
    case getVideoConsult(id: Int)
    case remindDoctor(id: Int)
}

extension ConsultApi {
    var path: String {
        switch self {
        case .consultList:
            return "/myconsult/getConsultList"
        case .getVideoConsult:
            return "/serConsultVideo/get"
        case .remindDoctor:
            return "/serConsultVideo/remindDoctorFaceTime"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .consultList(isFinished: isFinished, puid: puid):
            params["isFinished"] = isFinished ? "Y" : "N"
            params["pageNum"] = 1
            params["pageSize"] = 1000
            params["puid"] = puid
        case let .getVideoConsult(id: id):
            params["id"] = id
        case let .remindDoctor(id: id):
            params["id"] = id
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}