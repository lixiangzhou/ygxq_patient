//
//  SunnyDrugOrderDetailViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunnyDrugOrderDetailViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[Model]>([Model.docinfo(model: DoctorInfoModel())])
    
    var id = 0
    
    let showBottomProperty = MutableProperty<Bool>(false)
    
    func getDocData(_ did: Int) {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).startWithValues { [weak self] (docModel) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            
            models.insert(Model.docinfo(model: docModel ?? DoctorInfoModel()), at: 0)
            self.dataSourceProperty.value = models
        }
    }
    
    func getData() {
        SunnyDrugApi.orderInfo(id: id).rac_responseModel(SunnyDrugOrderModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = [Model]()
            
            models.append(Model.patient(model: model))
            
            if !model.notPassReason.isEmpty {
                models.append(Model.failReason(reason: model.notPassReason))
            }
            
            if !model.serDrugUesds.isEmpty {
                models.append(Model.buyedDrugs(drugs: model.serDrugUesds, price: model.totalPrices))
            }
            
            if !model.waybillNumber.isEmpty {
                var company = ""
                switch model.logisticsCompany {
                case 1: company = "圆通"
                case 2: company = "申通"
                default: break
                }
                models.append(Model.express(company: company, expNo: model.waybillNumber))
            }
            
            CommonApi.getFinishTaskMsgInfos(linkId: self.id, puid: patientId).rac_responseModel(ExamPicModel.self).startWithValues { [weak self] (m) in
                guard let self = self else { return }
                
                self.getDocData(model.duid)
                self.getAssistData(model.duid)
                
                if let m = m {
                    var temps = [Model]()
                    if m.showExams {
                        temps.append(.exam)
                    }
                    if m.showTidyInfo {
                        temps.append(.lookPics)
                    }
                    models.append(contentsOf: temps)
                }
                self.dataSourceProperty.value = models
            }
        }
    }
    
    func getAssistData(_ did: Int) {
        DoctorApi.assist(duid: did).rac_responseModel(DoctorAssistModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            
            models.append(Model.assist(model: model))
            self.dataSourceProperty.value = models
        }
    }
    
    func getDrugsString(_ models: [SunnyDrugModel]) -> String {
        var result = ""
        for (idx, model) in models.enumerated() {
            result += "\(model.drugName) * \(model.buyNum)"
            if idx != models.count - 1 {
                result += "\n"
            }
        }
        return result
    }
}

extension SunnyDrugOrderDetailViewModel {
    enum Model {
        case docinfo(model: DoctorInfoModel)
        case patient(model: SunnyDrugOrderModel)
        case buyedDrugs(drugs: [SunnyDrugModel], price: Double)
        case failReason(reason: String)
        case express(company: String, expNo: String)
        case assist(model: DoctorAssistModel)
        case exam
        case lookPics
    }
}
