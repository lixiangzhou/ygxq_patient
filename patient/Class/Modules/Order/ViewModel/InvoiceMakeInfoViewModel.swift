//
//  InvoiceMakeInfoViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/9.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceMakeInfoViewModel: BaseViewModel {
    let invoiceModelProperty = MutableProperty<InvoiceModel?>(nil)
    let selectTypeProperty = MutableProperty<InvoiceType>(.company)
    
    func getData() {
        OrderApi.lastInvoice(pid: patientId).rac_responseModel(InvoiceModel.self).skipNil().startWithValues { [weak self] (model) in
            self?.invoiceModelProperty.value = model
        }
    }
    
    var selectType: String {
        switch selectTypeProperty.value {
        case .company:
            return "PAY_INV_T_01"
        case .notCompany:
            return "PAY_INV_T_02"
        }
    }
}

extension InvoiceMakeInfoViewModel {
    enum InvoiceType {
        case company
        case notCompany
    }
}
