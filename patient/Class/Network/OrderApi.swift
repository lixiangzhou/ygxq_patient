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
}

extension OrderApi {
    var path: String {
        switch self {
        case .toPayOrderList:
            return "/order/orderList"
        case .payedOrderList:
            return "/order/stayPayment"
        case .refundOrderList:
            return "/order/refundOrder"
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
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
