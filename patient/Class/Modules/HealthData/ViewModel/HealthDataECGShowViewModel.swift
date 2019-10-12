//
//  HealthDataECGShowViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/12.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataECGShowViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[HealthDataECGModel]>([])
    var selectDate = Date()
    
    var selectDateECGModelProperty = MutableProperty<HealthDataECGModel>(HealthDataECGModel())
    
    var showTimes = [TimeInterval]()
    var showValues = [[Int]]()
    
    let isBuyECGProperty = MutableProperty<Bool>(false)
    func isBuyECG() {
        ECGApi.isBuyECG(pid: patientId, keyword: "UTOPIA13").rac_response(Bool.self).startWithValues { [weak self] (resp) in
            self?.isBuyECGProperty.value = resp.content == true
            if resp.isSuccess {
                self?.getData()
            }
        }
    }
    
    func checkToBuy(_ completion: @escaping (SunShineHutModel) -> Void) {
        ServiceApi.querySunshineHutList.rac_responseModel([SunShineHutModel].self).skipNil().startWithValues { (models) in
            if let model = models.first(where: { (m) -> Bool in
                return m.serCode == "UTOPIA13"
            }) {
                completion(model)
            }
        }
    }
    
    func getData() {
        if isBuyECGProperty.value {
            ECGApi.list7Ago(pid: patientId).rac_responseModel([HealthDataECGModel].self).skipNil().startWithValues { [weak self] (models) in
                if !models.isEmpty {
                    self?.dataSourceProperty.value = models
                } else {
                    HUD.show(toast: "当前无测量数据")
                }
            }
        }
    }
    
    func getLastData() {
        ECGApi.getLastOneByDate(pid: patientId, time: TimeInterval(Int(selectDate.timeIntervalSince1970 * 1000))).rac_response(HealthDataECGModel.self).startWithValues { [weak self] (resp) in
            if let model = resp.content {
                self?.selectDateECGModelProperty.value = model
            } else {
                HUD.show(toast: "当天没有进行测量")
            }
        }
    }
    
    func getStateString(_ model: HealthDataECGModel) -> String {
        switch model.emergency {
        case "1":
            return "普通"
        case "2":
            return "急"
        case "3":
            return "紧急"
        case "4":
            return "异常"
        default:
            return "--"
        }
    }
}
