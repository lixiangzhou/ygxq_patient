//
//  LongServiceViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LongServiceViewModel: BaseViewModel {

    var did = 0
    var indate = 0
    
    var index = 0
    
    let dataSourceProperty = MutableProperty<[Model]>([Model]())
    let doctorProperty = MutableProperty<DoctorInfoModel?>(nil)
    let servicesProperty = MutableProperty<[LongServiceModel]?>(nil)
    
    let hasOpenSerProperty = MutableProperty<Bool>(false)
    
    func getData() {
        getServiceInfo()
        getSers()
    }
    
    /// 获取套餐
    func getServices() {
        ServiceApi.queryServices(did: did).rac_responseModel([LongServiceModel].self).skipNil().startWithValues { [weak self] (result) in
            guard let self = self else { return }
            self.servicesProperty.value = result
            
            guard !self.dataSourceProperty.value.isEmpty, result.count >= self.index + 1 else { return }
            let outline = result[self.index]
            var models = self.dataSourceProperty.value
            models.append(Model.outline(model: outline))
            self.dataSourceProperty.value = models
        }
    }
    
    /// 获取服务详情
    func getServiceInfo() {
        ServiceApi.serviceInfo(did: did, pid: patientId, indate: indate).rac_responseModel([LongServiceModel].self).startWithValues { [weak self] (result) in
            self?.getServices()
            if let models = result, !models.isEmpty {
                self?.dataSourceProperty.value = [Model.docinfo(model: DoctorInfoModel()), Model.list(model: models)]
                self?.getDocData()
            } else {
                self?.dataSourceProperty.value = []
            }
        }
    }
    
    func getSers() {
        DoctorApi.serList(duid: did, puid: patientId).rac_responseModel([DoctorSerModel].self).startWithValues { [weak self] list in
            guard let self = self else { return }
            if let list = list {
                for m in list {
                    if !m.serType.hasPrefix("UTOPIA") {
                        if m.indate == self.indate {
                            self.hasOpenSerProperty.value = true
                            return
                        }
                    }
                }
                self.hasOpenSerProperty.value = false
            } else {
                self.hasOpenSerProperty.value = false
            }
        }
    }
    
    func getDocData() {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).skipNil().startWithValues { [weak self] (docModel) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            if models.isEmpty {
                self.doctorProperty.value = docModel
            } else {            
                models.removeFirst()
                models.insert(Model.docinfo(model: docModel), at: 0)
                self.dataSourceProperty.value = models
            }
        }
    }
    
    func getOrder(_ completion: @escaping (Int) -> Void) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard let services = servicesProperty.value, services.count >= index + 1 else {
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        let model = services[index]
        
        ServiceApi.buyPersonalService(duid: did, puid: patientId, serLongId: model.id.description, price: model.serPrice, productName: model.serName).rac_responseModel([String: Any].self).startWithValues { (result) in
            UIApplication.shared.endIgnoringInteractionEvents()
            if let orderId = result?["orderId"] as? Int {
                completion(orderId)
            }
        }
    }
}

extension LongServiceViewModel {
    enum Model {
        case docinfo(model: DoctorInfoModel)
        case list(model: [LongServiceModel])
        case outline(model: LongServiceModel)
    }
}
