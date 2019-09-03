//
//  VideoConsultBuyViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/30.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class VideoConsultBuyViewModel: BaseViewModel {
    
    var selectedModelsProperty = MutableProperty<NSMutableArray>(NSMutableArray())
    var selectedImagesProperty = MutableProperty<[UIImage]>([UIImage]())
    let orderIdProperty = MutableProperty<Int>(0)
    let myPrivateDoctorOrderProperty = MutableProperty<OrderModel?>(nil)
    let buyFromLongServiceSuccessProperty = MutableProperty<Bool>(false)
    
    var did = 0
    var serType = ""
    
    func getPrivateDoctor() {
        ServiceApi.isMyPrivateDoctor(did: did, pid: patientId, type: serType).rac_responseModel(OrderModel.self).skipNil().skip { $0.orderId == 0 }.startWithValues { [weak self] (value) in
            self?.myPrivateDoctorOrderProperty.value = value
        }
    }
    
    func buyVideoConsult(params: [String: Any]) {
        HUD.showLoding()
        UIApplication.shared.beginIgnoringInteractionEvents()
        var params = params
        if !selectedImagesProperty.value.isEmpty {
            var datas = [FileData]()
            for (idx, img) in selectedImagesProperty.value.enumerated() {
                datas.append(FileData(data: img.jpegData(compressionQuality: 1)!, name: "img\(idx).jpg"))
            }
            
            UploadApi.upload(datas: datas).rac_response([String].self).startWithValues { [weak self] (resp) in
                HUD.showError(BoolString(resp))
                if resp.isSuccess {
                    params["imgs"] = resp.content ?? []
                   self?._buyVideoConsult(params: params)
                } else {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    HUD.hideLoding()
                }
            }
        } else {
            _buyVideoConsult(params: params)
        }
    }
    
    func _buyVideoConsult(params: [String: Any]) {
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
            ServiceApi.buyVideoConsult(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                HUD.hideLoding()
                UIApplication.shared.endIgnoringInteractionEvents()
                HUD.showError(BoolString(resp))
                if resp.isSuccess {
                    self?.orderIdProperty.value = resp.content ?? 0
                }
            }
        }
    }
    
    func removeAt(index: Int) {
        var value = selectedImagesProperty.value
        value.remove(at: index)
        selectedImagesProperty.value = value
        selectedModelsProperty.value.removeObject(at: index)
    }
}
