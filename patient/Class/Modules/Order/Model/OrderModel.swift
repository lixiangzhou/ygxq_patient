//
//  OrderModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct OrderModel: ModelProtocol {
    var refundAmount: Double = 0
    var refundReason: String = ""
    var linkId: Int = 0
    var status: String = ""
    var isUsed: String = ""
//    var surplusNum:
    var orderType: String = ""
//    var isProtocol: Bool = false
    var payAmount: Double = 0.0
    var duid: Int = 0
//    var refundApply:
//    var serDrugUesds:
//    var patientRelatives:
    var id: Int = 0
//    var `protocol`:
//    var serviceMessages:
//    var refundTime:
//    var serProductId:
    var productName: String = ""
    var orderTime: TimeInterval = 0
}
