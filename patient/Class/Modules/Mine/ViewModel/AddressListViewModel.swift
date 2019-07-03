//
//  AddressListViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class AddressListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty([AddressModel]())
    
    func getList() {
        AddressApi.list(uid: patientId).rac_responseModel([AddressModel].self).skipNil().startWithValues { [unowned self] (models) in
            self.dataSourceProperty.value = models
        }
    }
}
