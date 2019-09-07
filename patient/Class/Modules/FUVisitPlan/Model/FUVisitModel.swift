//
//  FUVisitModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct FUVisitModel: ModelProtocol {
    var flupStatusFlag: String = ""
    var doctorAdvice: String = ""
    var failReason: String = ""
    var outTime: TimeInterval = 0
    var nextFlpTime: TimeInterval = 0
    var flpNum: Int = 0
    var flpTime: TimeInterval = 0
    var flupStatus: String = ""
    var duid: Int = 0
    var pushMessage: String = ""
    var finishedTime: TimeInterval = 0
    var fsfCHN: String = ""
    var imgs: [[String: String]] = []
    var id: Int = 0
    var contactTel: String = ""
    var fsCHN: String = ""
    var flpCfgId: Int = 0
    var answer: Bool = false
    var auid: Int = 0
    var isUploadInfo: Bool = false
    var resultId: [Int] = []
    var createTime: TimeInterval = 0
    var puid: Int = 0

}
