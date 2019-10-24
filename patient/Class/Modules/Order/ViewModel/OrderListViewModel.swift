//
//  OrderListViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class OrderListViewModel: BaseViewModel {
    
    var state: OrderState = .payed
    
    let dataSourceProperty = MutableProperty<[OrderModel]>([OrderModel]())
    
    var timers = [Int: Timer]()
    
    /// 18 分钟（ms）
    private let timeLimit = TimeInterval(18 * 60 * 1000)
    
    override init() {
        super.init()
    }
    
    func getStateString(model: OrderModel) -> String {
        switch state {
        case .payed:
            return "已支付"
        case .toPay:
            switch model.status {
            case "PAY_ORD_S_NEW": return "待支付"
            case "PAY_ORD_S_CLO": return "已取消"
            default: return ""
            }
        case .refund:
            switch model.status {
            case "PAY_ORD_S_REF_IN": return "退款中"
            case "PAY_ORD_S_REF_SUC": return "退款成功"
            case "PAY_ORD_S_REF_FAL": return "退款失败"
            default: return ""
            }
        }
    }
    
    func getData() {
        getOrderList(state).startWithValues { [weak self] (orders) in
            guard let self = self else { return }
            if let orders = orders, !orders.isEmpty {
                self.dataSourceProperty.value = orders
                self.removeAllTimer()
            }
        }
    }
    
    func getOrderList(_ state: OrderState) -> SignalProducer<[OrderModel]?, NoError> {
        switch state {
        case .toPay:
            return OrderApi.toPayOrderList(pageNum: 1, pageSize: 1000, pid: patientId).rac_responseModel([OrderModel].self)
        case .payed:
            return OrderApi.payedOrderList(pageNum: 1, pageSize: 1000, pid: patientId).rac_responseModel([OrderModel].self)
        case .refund:
            return OrderApi.refundOrderList(pageNum: 1, pageSize: 1000, pid: patientId).rac_responseModel([OrderModel].self)
        }
    }
    
    func refundIsApply(orderId: Int) -> SignalProducer<BoolString, NoError> {
        return OrderApi.refundIsApply(orderId: orderId).rac_response(None.self).map { BoolString($0) }
    }
    
    func deleteOrder(order: OrderModel) {
        OrderApi.deleteOrder(orderId: order.id).rac_response(String.self).map { BoolString($0) }.startWithValues { [unowned self] (result) in
            HUD.show(result)
            var orders = self.dataSourceProperty.value
            if result.isSuccess {
                orders.removeAll(where: { $0.id == order.id })
            }
            self.dataSourceProperty.value = orders
        }
    }
    
    func cancelOrder(order: OrderModel) {
        OrderApi.cancelOrder(orderId: order.id).rac_response(String.self).map { BoolString($0) }.startWithValues { [unowned self] (result) in
            HUD.show(result)
            if result.isSuccess {
                self.getData()
            }
        }
    }
    
    func showTimer(model: OrderModel) -> Bool {
        return (Date().timeIntervalSince1970 * 1000 - model.orderTime) < timeLimit
    }
    
    func removeTimer(_ key: Int) {
        let timer = timers[key]
        timer?.invalidate()
        timers[key] = nil
    }
    
    func saveTimer(_ key: Int, timer: Timer) {
        timers[key] = timer
    }
    
    func timerString(model: OrderModel) -> String {
        return (timeLimit - (Date().timeIntervalSince1970 * 1000 - model.orderTime)).toTime(format: "mm:ss") + "后自动取消订单"
    }
    
    func removeAllTimer() {
        for (_ ,v) in timers {
            v.invalidate()
        }
        timers.removeAll()
    }
    
    func updateModel(model: OrderModel) {
        var models = dataSourceProperty.value
        guard let idx = models.firstIndex(where: { $0.id == model.id }) else { return }
        
        models.replaceSubrange(idx...idx, with: [model])
        dataSourceProperty.value = models
    }
}
