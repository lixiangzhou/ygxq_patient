//
//  OrderApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum OrderApi: TargetType {
    case toPayOrderList(pageNum: Int, pageSize: Int, pid: Int)
    case payedOrderList(pageNum: Int, pageSize: Int, pid: Int)
    case refundOrderList(pageNum: Int, pageSize: Int, pid: Int)
    case refundIsApply(orderId: Int)
    case refundApply(pid: Int, orderId: Int, reason: String)
    case deleteOrder(orderId: Int)
    case cancelOrder(orderId: Int)
}

extension OrderApi {
    var path: String {
        switch self {
        case .toPayOrderList:
            return "/order/stayPayment"
        case .payedOrderList:
            return "/order/orderList"
        case .refundOrderList:
            return "/order/refundOrder"
        case .refundIsApply:
            return "/order/refund/isApply"
        case .refundApply:
            return "/order/refundApply"
        case .deleteOrder, .cancelOrder:
            return "/order/updatePayOrder"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .toPayOrderList(pageNum: pageNum, pageSize: pageSize, pid: pid):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["puid"] = pid
        case let .payedOrderList(pageNum: pageNum, pageSize: pageSize, pid: pid):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["puid"] = pid
        case let .refundOrderList(pageNum: pageNum, pageSize: pageSize, pid: pid):
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
            params["puid"] = pid
        case let .refundIsApply(orderId: orderId):
            params["orderId"] = orderId
        case let .refundApply(pid: pid, orderId: orderId, reason: reason):
            params["operator"] = pid
            params["orderId"] = orderId
            params["operateReason"] = reason
        case let .deleteOrder(orderId: orderId):
            params["id"] = orderId
            params["isDelete"] = "Y"
        case let .cancelOrder(orderId: orderId):
            params["id"] = orderId
            params["status"] = "PAY_ORD_S_CLO"
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
