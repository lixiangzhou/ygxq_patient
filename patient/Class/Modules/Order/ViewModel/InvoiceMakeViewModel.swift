//
//  InvoiceMakeViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceMakeViewModel: BaseViewModel {
    let submitResultProperty = MutableProperty<Bool>(false)
    
    var orderModels = [OrderModel]()
    
    func submit(params: [String: Any]) {
        OrderApi.invoiceApply(params: params).rac_response(String.self).startWithValues { [weak self] (resp) in
            HUD.show(BoolString(resp))
            self?.submitResultProperty.value = resp.isSuccess
        }
    }
    
    var orderIds: [Int] {
        var ids = [Int]()
        for model in orderModels {
            ids.append(model.id)
        }
        return ids
    }
    
    var amount: Double {
        var price = 0.0
        for model in orderModels {
            price += model.payAmount
        }
        return price
    }
}
