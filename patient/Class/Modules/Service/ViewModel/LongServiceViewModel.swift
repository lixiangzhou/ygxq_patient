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
    
    /// 获取套餐
    func getServices() {
        ServiceApi.queryServices(did: did).rac_responseModel([LongServiceModel].self).skipNil().startWithValues { [weak self] (result) in
            guard let self = self else { return }
            guard result.count >= self.index + 1 else { return }
            let outline = result[self.index]
            var models = self.dataSourceProperty.value
            models.append(Model.outline(model: outline))
            self.dataSourceProperty.value = models
        }
    }
    
    /// 获取服务详情
    func getServiceInfo() {
        ServiceApi.serviceInfo(did: did, pid: patientId, indate: indate).rac_responseModel([LongServiceModel].self).startWithValues { [weak self] (result) in
            if let models = result, !models.isEmpty {
                self?.dataSourceProperty.value = [Model.docinfo(model: DoctorInfoModel()), Model.list(model: models)]
                self?.getServices()
            }
            self?.getDocData()
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
}

extension LongServiceViewModel {
    enum Model {
        case docinfo(model: DoctorInfoModel)
        case list(model: [LongServiceModel])
        case outline(model: LongServiceModel)
    }
}
