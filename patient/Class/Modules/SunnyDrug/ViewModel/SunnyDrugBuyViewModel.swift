//
//  SunnyDrugBuyViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunnyDrugBuyViewModel: BaseViewModel {
    let myPrivateDoctorOrderProperty = MutableProperty<OrderModel?>(nil)
    let buyFromLongServiceSuccessProperty = MutableProperty<Bool>(false)
    let orderIdProperty = MutableProperty<Int>(0)
    let addressModelProperty = MutableProperty<AddressModel?>(nil)
    let selectImageProperty = MutableProperty<UIImage?>(nil)
    
    var did = 0
    var serType = ""
    
    func buySunnyDrug(params: [String: Any]) {
        HUD.showLoding()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var params = params
        let img = selectImageProperty.value!
        
        UploadApi.upload(datas: [FileData(data: img.jpegData(compressionQuality: 1)!, name: "img.jpg")]).rac_response([String].self).startWithValues { [weak self] (resp) in
            HUD.showError(BoolString(resp))
            if resp.isSuccess {
                params["idCardImg"] = resp.content?.first ?? ""
                self?._buySunnyDrug(params: params)
            } else {
                HUD.hideLoding()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    func _buySunnyDrug(params: [String: Any]) {
        if myPrivateDoctorOrderProperty.value != nil {
            ServiceApi.createWorkOrder(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                HUD.hideLoding()
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.show(BoolString(resp))
                if resp.isSuccess {
                    self?.buyFromLongServiceSuccessProperty.value = true
                }
            }
        } else {
            ServiceApi.buySunnyDrug(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                HUD.hideLoding()
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.showError(BoolString(resp))
                if resp.isSuccess {
                    self?.orderIdProperty.value = resp.content ?? 0
                }
            }
        }
    }
    
    func getPrivateDoctor() {
        ServiceApi.isMyPrivateDoctor(did: did, pid: patientId, type: serType).rac_responseModel(OrderModel.self).skipNil().skip { $0.orderId == 0 }.startWithValues { [weak self] (value) in
            self?.myPrivateDoctorOrderProperty.value = value
        }
    }
    
    func getDefaultAddress() {
        AddressApi.payDeaultAddress(pid: patientId).rac_responseModel(AddressModel.self).startWithValues { [weak self] (model) in
            self?.addressModelProperty.value = model
        }
    }
}
