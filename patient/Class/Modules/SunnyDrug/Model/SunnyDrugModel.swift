//
//  SunnyDrugModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct SunnyDrugOrderModel: ModelProtocol, Equatable {
    var address: String = ""
    var isPassCheck: String = ""
    var logisticsCompany: Int = 0
    var serExam: String = ""
    var drugName: String = ""
    var notPassReason: String = ""
    var realName: String = ""
    var idCardImg: String = ""
    var serExamResult: String = ""
    var serConsultVideoId: Int = 0
    var duid: Int = 0
    var pushMessage: String = ""
    var id: Int = 0
    var isDoctorLook: Bool = false
    var mobile: String = ""
    var isCompleteNum: Int = 0
    var auid: Int = 0
    var isCompleteInfo: Bool = false
    var createTime: TimeInterval = 0
    var remark: String = ""
    var waybillNumber: String = ""
    var puid: Int = 0
    var serStatus: Int = 0
    
//    var medias: []
//    var fromWhere: String = ""
    var totalPrices: Double = 0.0
    var doctorAdvice: String = ""
//    var payOrder: [:]
    var examResultUnlookCount: Int = 0
    var imgs: [ImageModel] = [ImageModel]()
    var checklists: [CheckRecordModel] = [CheckRecordModel]()
    var cases: [CaseRecordModel] = [CaseRecordModel]()
    var msgNum: Int = 0
    var serDrugUesds: [SunnyDrugModel] = [SunnyDrugModel]()
//    var serverIds:
}

struct SunnyDrugModel: ModelProtocol, Equatable {
    var puid: Int = 0
    var buyNum: Int = 0
    var id: Int = 0
    var serDrugSunnyBuysId: Int = 0
    var packSpec: String = ""
    var unitPrice: Int = 0
    var drugName: String = ""
    var serConsultVideoId: Int = 0
    var drugUsage: String = ""
    var serDrugCfgId: Int = 0
    var createTime: TimeInterval = 0
}
