//
//  HealthDataShowViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataShowViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[HealthDataModel]>([])
    var type = ""
    var selectDate = Date()
    var needMinutes = false
    
    var showTimes = [TimeInterval]()
    var showValues = [[Int]]()
    
    func getData() {
        var type = self.type
        if self.type == "HLR_HLG_T_01" {
            type = "HLR_HLG_T_01,HLR_HLG_T_02"
        }
        HealthApi.queryHealthLogList(pid: patientId, type: type, time: TimeInterval(Int(selectDate.timeIntervalSince1970 * 1000))).rac_responseModel([HealthDataModel].self).skipNil().startWithValues { [weak self] (models) in
            if !models.isEmpty {
                self?.dataSourceProperty.value = models
            } else {
                HUD.show(toast: "当前无测量数据")
            }
        }
    }

    var title: String {
        switch type {
        case "HLR_HLG_T_10":
            return "心率数据"
        case "HLR_HLG_T_01":
            return "血压数据"
        case "HLR_HLG_T_11":
            return "心电数据"
        default: return ""
        }
    }
    
    var lineTitle: String {
        switch type {
        case "HLR_HLG_T_10":
            return "心率值(次/分)"
        case "HLR_HLG_T_01":
            return "血压值(mmHg)"
        case "HLR_HLG_T_11":
            return "心率值(bpm)"
        default: return ""
        }
    }

}
