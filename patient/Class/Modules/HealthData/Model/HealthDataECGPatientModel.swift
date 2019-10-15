//
//  HealthDataECGPatientModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct HealthDataECGPatientModel: ModelProtocol {
    var puid: Int = 0
    var realName: String = ""
    var id: Int = 0
    var birth: TimeInterval?
    var isDelete: String = ""
    var isDefault: String = ""
    var sex: Int = 0
    var createTime: TimeInterval = 0
}
