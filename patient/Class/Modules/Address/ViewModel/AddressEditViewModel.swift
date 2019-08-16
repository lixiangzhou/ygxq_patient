//
//  AddressEditViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class AddressEditViewModel: BaseViewModel {
    let selectAreaModel: MutableProperty<AreaModel?> = MutableProperty(nil)
    
    var mode: AddressEditController.Mode!
    
    func update(mode: AddressEditController.Mode, id: Int, uid: Int, name: String, mobile: String, districtId: Int, district: String, address: String, isDefault: Bool) -> SignalProducer<BoolString, NoError> {
        switch mode {
        case .add:
            return add(id: id, uid: patientId, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault)
        case .update:
            return update(id: id, uid: patientId, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault)
        }
    }
    
    func add(id: Int, uid: Int, name: String, mobile: String, districtId: Int, district: String, address: String, isDefault: Bool) -> SignalProducer<BoolString, NoError> {
        return AddressApi.add(id: id, uid: uid, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault).rac_response(String.self).map { BoolString($0) }
    }
    
    func update(id: Int, uid: Int, name: String, mobile: String, districtId: Int, district: String, address: String, isDefault: Bool) -> SignalProducer<BoolString, NoError> {
        return AddressApi.update(id: id, uid: uid, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault).rac_response(String.self).map { BoolString($0) }
    }
    
    func delete(id: Int) -> SignalProducer<BoolString, NoError> {
        return AddressApi.delete(id: id).rac_response(String.self).map { BoolString($0) }
    }
}
