//
//  VideoConsultModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct VideoConsultModel: ModelProtocol {
    var serConsultVideo: VideoConsultSerModel = VideoConsultSerModel()
    var medias: [ImageModel] = [ImageModel]()
    var examResultUnlookCount: Int = 0
    var checklists: [CheckRecordModel] = [CheckRecordModel]()
    var leftSeconds: Int = 0
    var cases: [CaseRecordModel] = [CaseRecordModel]()
    var drugBuys: Bool = false
}

struct VideoConsultSerModel: ModelProtocol {
    var isBuyDrug: Bool = false
    var doctorAdvice: String = ""
    var isLook: String = ""
    var hospitalPuid: String = ""
    var realName: String = ""
    var lastRemindTime: TimeInterval = 0
    var serExamResult: String = ""
    var disease: String = ""
    var duid: Int = 0
    var clientConsultStatus: String = ""
    var endTime: TimeInterval = 0
    var remindNum: Int = 0
    var pushMessage: String = ""
    var id: Int = 0
    var totalPrices: Int = 0
    var consultStatus: String = ""
    var consultContent: String = ""
    var mobile: String = ""
    var idCardNo: String = ""
    var auid: Int = 0
    var isCompleteInfo: Bool = false
    var appointTime: TimeInterval = 0
    var createTime: TimeInterval = 0
    var talkTime: TimeInterval = 0
    var isCompleteNum: Int = 0
    var firstTime: TimeInterval = 0
    var puid: Int = 0
    var serExam: String = ""
}
