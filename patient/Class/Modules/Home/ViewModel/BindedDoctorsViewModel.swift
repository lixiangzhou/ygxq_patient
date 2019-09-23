//
//  BindedDoctorsViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class BindedDoctorsViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[DoctorInfoModel]>([DoctorInfoModel]())
    
    func getData() {
        PatientApi.bindedDoctors(puid: patientId).rac_responseModel([DoctorInfoModel].self).startWithValues { [weak self] (result) in
            guard let self = self else { return }
            self.dataSourceProperty.value = result ?? []
        }
    }
}
