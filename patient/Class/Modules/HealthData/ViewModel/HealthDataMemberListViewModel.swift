//
//  HealthDataMemberListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataMemberListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[HealthDataECGPatientModel]>([])
    
    func queryPatientConsultantList() {
        CommonApi.queryPatientConsultantList(pid: patientId).rac_responseModel([HealthDataECGPatientModel].self).startWithValues { [weak self] (models) in
            self?.dataSourceProperty.value = models ?? []
        }
    }
}
