//
//  AddressShowViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class AddressShowViewModel: BaseViewModel {
    let addressModelProperty = MutableProperty<AddressModel?>(nil)
    
    func getDefaultAddress() {
        AddressApi.payDeaultAddress(pid: patientId).rac_responseModel(AddressModel.self).startWithValues { [weak self] (model) in
            self?.addressModelProperty.value = model
        }
    }
}
