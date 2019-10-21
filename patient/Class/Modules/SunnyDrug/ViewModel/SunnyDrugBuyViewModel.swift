//
//  SunnyDrugBuyViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunnyDrugBuyViewModel: BaseViewModel {
    let myPrivateDoctorOrderProperty = MutableProperty<OrderModel>(OrderModel())
    let buyFromLongServiceSuccessProperty = MutableProperty<Bool>(false)
    let orderIdProperty = MutableProperty<Int>(0)
    let selectImageProperty = MutableProperty<UIImage?>(nil)
    let priceProperty = MutableProperty<Double>(0)
    
    var backAction: PayViewModel.ResultAction?
    /// 如果有值，说明是视频后的购药，必须微信支付
    var serVideoId: Int?
    
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
        if isToPayWay {
            ServiceApi.buySunnyDrug(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                HUD.hideLoding()
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.showError(BoolString(resp))
                if resp.isSuccess {
                    self?.orderIdProperty.value = resp.content ?? 0
                }
            }
        } else {
            ServiceApi.createWorkOrder(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                HUD.hideLoding()
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.show(BoolString(resp))
                if resp.isSuccess {
                    self?.buyFromLongServiceSuccessProperty.value = true
                }
            }
        }
    }
    
    var isToPayWay: Bool {
        return serVideoId != nil || myPrivateDoctorOrderProperty.value.ser_code.isEmpty
    }
    
    func getPrivateDoctor() {
        ServiceApi.isMyPrivateDoctor(did: did, pid: patientId, type: serType).rac_responseModel(OrderModel.self).skipNil().skip { $0.orderId == 0 }.startWithValues { [weak self] (value) in
            self?.myPrivateDoctorOrderProperty.value = value
        }
    }
    
    func getDrugPrice() {
        if isToPayWay {        
            ServiceApi.getDrugPrice(did: did, serType: "UTOPIA16").rac_responseModel(LongServiceModel.self).startWithValues { [weak self] (model) in
                self?.priceProperty.value = model?.serPrice ?? 0
            }
        }
    }

}
