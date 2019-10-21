//
//  HealthDataViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/8.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[HealthDataModel]>([])
    let xdDataProperty = MutableProperty<HealthDataECGModel?>(nil)
    
    func getData() {
        ECGApi.getLastOneByDate(pid: patientId, time: nil).rac_responseModel(HealthDataECGModel.self).startWithValues { [weak self] (model) in
            self?.xdDataProperty.value = model
        }
        
        HealthApi.queryHealthLogs(pid: patientId).rac_responseModel([HealthDataModel].self).startWithValues { [weak self] (models) in
            if var models = models {
                models.removeAll { (model) -> Bool in
                    switch model.healthLogType {
                    case "HLR_HLG_T_11", "HLR_HLG_T_10", "HLR_HLG_T_01": return false
                    default: return true
                    }
                }
                self?.dataSourceProperty.value = models
            } else {
                self?.dataSourceProperty.value = []
            }
        }
    }
    
    func getIcon(model: HealthDataModel) -> UIImage? {
        switch model.healthLogType {
        case "HLR_HLG_T_11":
            return UIImage(named: "health_xd")
        case "HLR_HLG_T_10":
            return UIImage(named: "health_xl")
        case "HLR_HLG_T_01":
            return UIImage(named: "health_xy")
        default: return nil
        }
    }
    
    func getValue(model: HealthDataModel) -> NSAttributedString? {
        if model.healthLogValue != nil || model.healthLogValues != nil {
            var value = model.healthLogValues
            if value == nil {
                value = model.healthLogValue!.description
            }
            let attr = NSMutableAttributedString(string: value!, attributes: [NSAttributedString.Key.font: UIFont.size(25), NSAttributedString.Key.foregroundColor: UIColor.c407cec])
            attr.append(NSAttributedString(string: model.unit, attributes: [NSAttributedString.Key.font: UIFont.size(12), NSAttributedString.Key.foregroundColor: UIColor.c6]))
            return attr
        } else {
            return NSAttributedString(string: "━ ━", attributes: [NSAttributedString.Key.font: UIFont.size(30), NSAttributedString.Key.foregroundColor: UIColor.c407cec])
        }
    }
}
