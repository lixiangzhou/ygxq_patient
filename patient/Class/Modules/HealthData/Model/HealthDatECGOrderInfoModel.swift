//
//  HealthDatECGOrderInfoModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct HealthDatECGOrderInfoModel: ModelProtocol {
    var realName: String = ""
    var surplusNum: Int?
    var mobile: String = ""
    var equipmentName: String = ""
    var dueDate: TimeInterval?
    var waybillNumber: Int = 0
    var puid: Int = 0
    var price: Double = 0
    var address: String = ""
    var orderId: Int = 0
    var logisticsCompany: String = ""
    var serCode: String = ""
    var serName: String = ""
}
