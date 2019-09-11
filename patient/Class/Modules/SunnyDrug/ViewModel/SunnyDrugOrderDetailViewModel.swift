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
    
    var did = 0
    var id = 0
    
    let showBottomProperty = MutableProperty<Bool>(false)
    
    func getDocData() {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).startWithValues { [weak self] (docModel) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.removeAll(where: { model in
                if case Model.docinfo = model {
                    return true
                } else {
                    return false
                }
            })
            
            models.insert(Model.docinfo(model: docModel ?? DoctorInfoModel()), at: 0)
            self.dataSourceProperty.value = models
        }
    }
    
    func getData() {
        SunnyDrugApi.orderInfo(id: id).rac_responseModel(SunnyDrugOrderModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.removeAll(where: { model in
                switch model {
                case .docinfo, .assist: return false
                default: return true
                }
            })
            
            var temp = [Model]()
            
            temp.append(Model.patient(model: model))
            
            if !model.notPassReason.isEmpty {
                temp.append(Model.failReason(reason: model.notPassReason))
            }
            
            if !model.serDrugUesds.isEmpty {
                temp.append(Model.buyedDrugs(drugs: model.serDrugUesds, price: model.totalPrices))
            }
            
            if !model.waybillNumber.isEmpty {
                var company = ""
                switch model.logisticsCompany {
                case 1: company = "圆通"
                case 2: company = "申通"
                default: break
                }
                temp.append(Model.express(company: company, expNo: model.waybillNumber))
            }
            
            models.insert(contentsOf: temp, at: 1)
            
            self.dataSourceProperty.value = models
        }
    }
    
    func getAssistData() {
        DoctorApi.assist(duid: did).rac_responseModel(DoctorAssistModel.self).skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            var models = self.dataSourceProperty.value
            models.removeAll(where: { model in
                switch model {
                case .assist: return true
                default: return false
                }
            })
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
    }
}
