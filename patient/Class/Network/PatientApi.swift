//
//  PatientApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum PatientApi: TargetType {
    case bindingDoctor(code: String, puid: Int)
    case bindedDoctors(puid: Int)
}

extension PatientApi {
    var path: String {
        switch self {
        case .bindingDoctor:
            return "/patient/bindingdoctor"
        case .bindedDoctors:
            return "/patient/bindingdoctorlist"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .bindingDoctor(code: code, puid: puid):
            params["inviteCode"] = code
            params["puid"] = puid
        case let .bindedDoctors(puid: puid):
            params["puid"] = puid
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}

