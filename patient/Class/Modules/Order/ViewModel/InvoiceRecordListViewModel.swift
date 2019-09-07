//
//  InvoiceRecordListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceRecordListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[InvoiceModel]>([])
    
    func getData() {
        OrderApi.invoiceHistory(pageNum: 1, pageSize: 1000, pid: patientId).rac_responseModel([InvoiceModel].self).startWithValues { [weak self] (models) in
            self?.dataSourceProperty.value = models ?? []
        }
    }
}
