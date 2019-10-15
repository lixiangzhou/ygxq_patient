//
//  HealthDataECGHistoryViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataECGHistoryViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[[HealthDataECGModel]]>([])
    func getData() {
        ECGApi.queryEcg12List(pid: 1012).rac_responseModel([[HealthDataECGModel]].self).startWithValues { [weak self] (models) in
            self?.dataSourceProperty.value = models ?? []
        }
    }
}
