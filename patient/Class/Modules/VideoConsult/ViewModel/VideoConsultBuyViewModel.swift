//
//  VideoConsultBuyViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/30.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class VideoConsultBuyViewModel: BaseViewModel {
    /// 用于选择图片回显时使用
    var selectedModelsProperty = MutableProperty<NSMutableArray>(NSMutableArray())
    var selectedImagesProperty = MutableProperty<[UIImage]>([UIImage]())
    let orderIdProperty = MutableProperty<Int>(0)
    let myPrivateDoctorOrderProperty = MutableProperty<OrderModel?>(nil)
    let buyFromLongServiceSuccessProperty = MutableProperty<Bool>(false)
    
    var did = 0
    var serType = ""
    
    var tipString: String {
        var tipString = "温馨提示：视频咨询服务按次收费，每次总时长不可超过30分钟，请您把控好就诊时间。所有问题均由医生本人回复，医生临床工作繁忙，均在休息时上网，一般在24小时内回复，请耐心等待。"
        if did == 1026 {
            tipString += "\n毛主任的视频问诊时间为每周二16:00-17:00和每周四11:00-12:00，请您购买后耐心等待。"
        }
        return tipString
    }
    
    var isToPayWay: Bool {
        return myPrivateDoctorOrderProperty.value == nil
    }

    
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
        if !isToPayWay {
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
