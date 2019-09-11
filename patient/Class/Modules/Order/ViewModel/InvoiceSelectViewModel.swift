//
//  InvoiceSelectViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceSelectViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[OrderModel]>([])
    
    func getData() {
        OrderApi.invoiceList(pageNum: 1, pageSize: 1000, pid: patientId).rac_responseModel([OrderModel].self).startWithValues { [weak self] (orders) in
            self?.dataSourceProperty.value = orders ?? []
        }
    }
    
    func selectAt(_ index: Int) {
        var orders = dataSourceProperty.value
        
        var model = orders[index]
        model.isSelected = !model.isSelected
        
        orders.replaceSubrange(index...index, with: [model])
        dataSourceProperty.value = orders
    }
    
    func selectAll(_ isAll: Bool) {
        let orders = dataSourceProperty.value
        
        var newOrders = [OrderModel]()
        for o in orders {
            var newOrder = o
            newOrder.isSelected = isAll
            newOrders.append(newOrder)
        }
        
        dataSourceProperty.value = newOrders
    }
    
    var selectedOrders: [OrderModel] {
        var orders = [OrderModel]()
        for o in dataSourceProperty.value {
            if o.isSelected {
                orders.append(o)
            }
        }
        return orders
    }
}
