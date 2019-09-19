//
//  ExamModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct ExamModel: ModelProtocol, Equatable {
    var id: Int = 0
    var resultId: Int = 0
    var quesCount: Int = 0
    var isLook: String = ""
    var examName: String = ""
    var isEffect: String = ""
    var createTime: TimeInterval = 0
    var type: String = ""
    var isFinished: Int = 0
    
    var serExamName = ""
    var linkId = 0
}

struct ExamResultModel: ModelProtocol, Equatable {
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
    var mobile: Int = 0
    var idCardNo: String = ""
    var auid: Int = 0
    var isCompleteInfo: Bool = false
    var appointTime: TimeInterval = 0
    var createTime: Int = 0
    var talkTime: TimeInterval = 0
    var isCompleteNum: Int = 0
    var firstTime: TimeInterval = 0
    var puid: Int = 0
    var serExam: String = ""

}


