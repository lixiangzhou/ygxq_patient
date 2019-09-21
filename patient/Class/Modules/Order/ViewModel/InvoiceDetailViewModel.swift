//
//  InvoiceDetailViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceDetailViewModel: BaseViewModel {
    let modelProperty = MutableProperty<InvoiceModel?>(nil)
    
    var isFinished: Bool {
        if let model = modelProperty.value {
            return model.invoiceStatus != 1
        } else {
            return false
        }
    }
}
