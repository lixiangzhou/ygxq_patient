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
    let myPrivateDoctorOrderProperty = MutableProperty<OrderModel>(OrderModel())
    let buyFromLongServiceSuccessProperty = MutableProperty<Bool>(false)
    let lastPatientInfoModelProperty = MutableProperty<TelPatientModel>(TelPatientModel())
    let priceProperty = MutableProperty<Double>(0)
    
    var did = 0
    
    var serType = ""
    
    func getPatientData() {
        if serType == "UTOPIA15" {
            PatientManager.shared.getPatientInfo()
        } else if serType == "UTOPIA10" {
            getLastInfo()
        }
    }
    
    func getLastInfo() {
        TelApi.getLastInfo(pid: patientId).rac_responseModel(TelPatientModel.self).skipNil().startWithValues { [weak self] (model) in
            self?.lastPatientInfoModelProperty.value = model
        }
    }
    
    func getPrivateDoctor() {
        ServiceApi.isMyPrivateDoctor(did: did, pid: patientId, type: serType).rac_responseModel(OrderModel.self).skipNil().startWithValues { [weak self] (value) in
            self?.myPrivateDoctorOrderProperty.value = value
        }
    }
    
    func buyConsult(params: [String: Any]) {
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
                   self?._buyConsult(params: params)
                } else {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    HUD.hideLoding()
                }
            }
        } else {
            _buyConsult(params: params)
        }
    }
        
    func _buyConsult(params: [String: Any]) {
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
            switch serType {
            case "UTOPIA10":
                TelApi.addSerConsultTel(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                    HUD.hideLoding()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    HUD.showError(BoolString(resp))
                    if resp.isSuccess {
                        self?.orderIdProperty.value = resp.content ?? 0
                    }
                }
            case "UTOPIA15":
                ServiceApi.buyVideoConsult(params: params).rac_response(Int.self).startWithValues { [weak self] (resp) in
                    HUD.hideLoding()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    HUD.showError(BoolString(resp))
                    if resp.isSuccess {
                        self?.orderIdProperty.value = resp.content ?? 0
                    }
                }
            default: break
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

extension VideoConsultBuyViewModel {
    var tipString: String {
        switch serType {
        case "UTOPIA10":
            var tipString = "温馨提示：电话咨询服务按次收费，每次总时长不可超过15分钟，请您把控好就诊时间。所有问题均由医生本人回复，医生临床工作繁忙，均在休息时上网，一般在24小时内回复，请耐心等待并留意010开头的来电。"
            if did == 1026 {
                tipString += "\n毛主任的电话问诊时间为每周二16:00-17:00和每周四11:00-12:00，请您购买后耐心等耐。"
            }
            
            return tipString
        case "UTOPIA15":
            var tipString = "温馨提示：视频咨询服务按次收费，每次总时长不可超过30分钟，请您把控好就诊时间。所有问题均由医生本人回复，医生临床工作繁忙，均在休息时上网，一般在24小时内回复，请耐心等待。"
            if did == 1026 {
                tipString += "\n毛主任的视频问诊时间为每周二16:00-17:00和每周四11:00-12:00，请您购买后耐心等待。"
            }
            return tipString
        default: return ""
        }
    }
    
    
    
    var topTipString: String {
        switch serType {
        case "UTOPIA10":
            var tipString = "提示：急重症患者不适合电话咨询，请及时前往医院就医。"
            if serType == "UTOPIA10" {
                tipString += "为确保与医生正常通话，请您务必填写正确的手机号码。"
            }
            
            return tipString
        case "UTOPIA15":
            let tipString = "提示：急重症患者不适合视频咨询，请及时前往医院就医。"
            return tipString
        default: return ""
        }
    }
    
    var title: String? {
        switch serType {
        case "UTOPIA10":
            return "电话咨询"
        case "UTOPIA15":
            return "视频咨询"
        default: return ""
        }
    }
    
    var isToPayWay: Bool {
        return myPrivateDoctorOrderProperty.value.ser_code.isEmpty
    }
    
    var alertMsg: String {
        var type = ""
        switch serType {
        case "UTOPIA10":
            type = "电话"
        case "UTOPIA15":
            if isToPayWay {
                type = "视频"
            } else {
                return "您还有未完成的视频咨询服务，请完成后再次发起"
            }
        default: break
        }
        return "您还有未完成的\(type)咨询服务，请确认是否再次购买"
    }
    
    var toastMsg: String {
        switch serType {
        case "UTOPIA10":
            return "您还有未完成的电话咨询服务，请完成后再次发起"
        case "UTOPIA15":
            return "您还有未完成的视频咨询服务，请完成后再次发起"
        default: return ""
        }
    }
    
    
    
    var cantBuy: Bool {
        return (Int(myPrivateDoctorOrderProperty.value.unfinishConsult) ?? 0) > 0
    }
}

extension VideoConsultBuyViewModel {
    
}
