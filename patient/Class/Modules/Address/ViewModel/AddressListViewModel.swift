//
//  AddressListViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class AddressListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty([AddressModel]())
    
    var addressModel: AddressModel?
    
    func getAddressModel() -> AddressModel? {
        if let model = addressModel {
            let values = dataSourceProperty.value
            for v in values {
                if v.id == model.id {
                    return v
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    func getList() {
        AddressApi.list(uid: patientId).rac_responseModel([AddressModel].self).startWithValues { [unowned self] (models) in
            self.dataSourceProperty.value = models ?? []
        }
    }
}
