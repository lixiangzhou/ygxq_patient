//
//  InvoiceContentViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceContentViewModel: BaseViewModel {
    var id = 0
    
    let dataSourceProperty = MutableProperty<[OrderModel]>([])
    
    func getData() {
        if id > 0 {        
            OrderApi.invoiceHistoryDetail(id: id).rac_responseModel([OrderModel].self).startWithValues { [weak self] (models) in
                self?.dataSourceProperty.value = models ?? []
            }
        }
    }
}
