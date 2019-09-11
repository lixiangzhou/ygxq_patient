//
//  LongServiceDoctorListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LongServiceDoctorListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[DoctorInfoModel]>([DoctorInfoModel]())
    
    func getData() {
        ServiceApi.privateDocList(pid: patientId).rac_responseModel([DoctorInfoModel].self).skipNil().startWithValues { [weak self] (result) in
            guard let self = self else { return }
            self.dataSourceProperty.value = result
        }
    }
}
