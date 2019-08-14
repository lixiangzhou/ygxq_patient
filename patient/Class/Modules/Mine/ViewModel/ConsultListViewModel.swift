//
//  ConsultListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/14.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

enum ConsultState {
    case ing
    case finished
}

class ConsultListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[ConsultModel]>([ConsultModel]())
    
    var state = ConsultState.ing
    
    func getData() {
        ConsultApi.consultList(isFinished: state == .finished, puid: patientId).rac_responseModel([ConsultModel].self).startWithValues { [weak self] (result) in
            self?.dataSourceProperty.value = result ?? [ConsultModel]()
        }
    }
}
