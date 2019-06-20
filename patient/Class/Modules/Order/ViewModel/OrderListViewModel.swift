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
    let (reloadSignal, reloadObserver) = Signal<(), NoError>.pipe()
    
    override init() {
        super.init()
    }
    
    func getStateString(model: OrderModel) -> String {
        switch state {
        case .payed:
            return "已支付"
        case .toPay:
            return "待支付"
        case .refund:
            return ""
        }
    }
    
    func getOrderList() {
        getOrderList(state).startWithValues { [weak self] (orders) in
            guard let self = self else { return }
            if let orders = orders, !orders.isEmpty {
                self.dataSourceProperty.value = self.dataSourceProperty.value + orders
                self.reloadObserver.send(value: ())
            }
        }
    }
    
    func getOrderList(_ state: OrderState) -> SignalProducer<[OrderModel]?, NoError> {
        switch state {
        case .toPay:
            return OrderApi.toPayOrderList(pageNum: 1, pageSize: 1000, pid: PatientManager.shared.id).rac_responseModel([OrderModel].self)
        case .payed:
            return OrderApi.payedOrderList(pageNum: 1, pageSize: 1000, pid: PatientManager.shared.id).rac_responseModel([OrderModel].self)
        case .refund:
            return OrderApi.refundOrderList(pageNum: 1, pageSize: 1000, pid: PatientManager.shared.id).rac_responseModel([OrderModel].self)
        }
    }
}
