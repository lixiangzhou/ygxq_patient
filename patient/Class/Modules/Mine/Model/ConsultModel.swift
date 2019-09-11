//
//  ConsultModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct ConsultModel: ModelProtocol, Equatable {
    var linkId: Int = 0
    var isLook: Bool = false
    var sex: Sex = .unknown
    var realName: String = ""
    var consultContentPa: String = ""
    var eId: Int = 0
    var duid: Int = 0
    var qiyuId: Int = 0
    var finishedTime: TimeInterval = 0
    var id: Int = 0
    var consultContent: String = ""
    var mobile: String = ""
    var serCode: String = ""
    var imgUrl: String = ""
    var isFinished: String = ""
    var isEvaluated: Int = 0
    var titleName: String = ""
    var hospitalName: String = ""
    var createTime: TimeInterval = 0
    var serName: String = ""
    var solution: String = ""
    var workId: Int = 0
    var puid: Int = 0
}
