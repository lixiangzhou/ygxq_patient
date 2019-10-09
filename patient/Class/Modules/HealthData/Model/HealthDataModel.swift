//
//  HealthDataModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/8.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct HealthDataModel: ModelProtocol {
    var id: Int = 0
    var uploadUid: Int = 0
    var description: String = ""
    var unit: String = ""
    var healthLogType: String = ""
    var uploadWay: String = ""
    var puid: Int = 0
    var createTime: TimeInterval?
//    var uploadType:
    var healthLogValues: String?
    var healthLogValue: Int?
//    var hlrHealthLogExerciseList:
}
