//
//  InvoiceModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct InvoiceModel: ModelProtocol {
    var id: Int = 0
    var invoiceStatus: Int = 0
    var realName: String = ""
    var invoiceTitle: String = ""
    var mobile: Int = 0
    var invoiceType: String = ""
    var waybillNumber: String = ""
    var invoiceContent: String = ""
    var puid: Int = 0
    var moreInfo: String = ""
    var address: String = ""
    var finishedTime: TimeInterval = 0
    var createTime: TimeInterval = 0
    var logisticsCompany: Int = 0
    var invoiceAmount: Double = 0.0
    var district: String = ""
    var taxpayerNum: String = ""
}
