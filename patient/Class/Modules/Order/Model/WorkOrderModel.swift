//
//  WorkOrderModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct WorkOrderModel: ModelProtocol {
    var id: Int = 0
    var keyObject: String = ""
    var clientType: String = ""
    var isFinished: String = ""
    var puid: Int = 0
    var osType: String = ""
    var workType: String = ""
    var isPay: String = ""
    var workStatus: String = ""
    var finishedTime: TimeInterval = 0
    var createTime: TimeInterval = 0
    var linkId: Int = 0
    var auid: Int = 0

}
