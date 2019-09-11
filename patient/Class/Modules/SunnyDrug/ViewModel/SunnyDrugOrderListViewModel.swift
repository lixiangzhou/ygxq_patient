//
//  SunnyDrugOrderListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

enum SunnyDrugOrderState: Int {
    case ing = 1
    case success = 2
    case failed = 3
}

class SunnyDrugOrderListViewModel: BaseViewModel {
    var state = SunnyDrugOrderState.ing
    
    let dataSourceProperty = MutableProperty<[SunnyDrugOrderModel]>([SunnyDrugOrderModel]())
    
    func getData() {
        SunnyDrugApi.orders(pid: patientId, state: state).rac_responseModel([SunnyDrugOrderModel].self).skipNil().startWithValues { [weak self] (orders) in
            self?.dataSourceProperty.value = orders
        }
    }
}
