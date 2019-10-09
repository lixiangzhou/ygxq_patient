//
//  HealthDataInputViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataInputViewModel: BaseViewModel {
    var type: String = ""
    var selectedDate = Date()
    
    var values = [Int]()
    
    var saveResultProperty = MutableProperty<Bool>(false)
    
    func save() {
        var lgs = [[String: Any]]()
        let time = Int(selectedDate.timeIntervalSince1970 * 1000)
        switch type {
        case "HLR_HLG_T_10":
            if let value = values.first {
                lgs.append(["createTime": time, "healthLogType": "HLR_HLG_T_10", "healthLogValue": value])
            }
        case "HLR_HLG_T_01":
            if let value = values.first {
                lgs.append(["createTime": time, "healthLogType": "HLR_HLG_T_01", "healthLogValue": value])
            }
            if values.count >= 2 {
                lgs.append(["createTime": time, "healthLogType": "HLR_HLG_T_02", "healthLogValue": values[1]])
            }
        default:
            break
        }
        
        let params: [String: Any] = ["logs": lgs, "puid": patientId, "uploadType": "M", "uploadUid": patientId]
        HealthApi.addLog(params: params).rac_response(String.self).startWithValues { [weak self] (resp) in
            self?.saveResultProperty.value = resp.isSuccess
            HUD.show(BoolString(resp))
        }
    }
    
    let bigAttributes = [NSAttributedString.Key.foregroundColor: UIColor.cff9a21, NSAttributedString.Key.font: UIFont.boldSize(26)]
    let smallAttributes = [NSAttributedString.Key.foregroundColor: UIColor.c3, NSAttributedString.Key.font: UIFont.size(12)]
    
    func heartRate(value: Int) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: String(value), attributes: bigAttributes)
        attr.append(NSAttributedString(string: " 次/分", attributes: smallAttributes))
        return attr
    }
    
    func bloodPresureHight(value: Int) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: "高压 ", attributes: smallAttributes)
        attr.append(NSAttributedString(string: String(value), attributes: bigAttributes))
        attr.append(NSAttributedString(string: " mmHg", attributes: smallAttributes))
        return attr
    }
    
    func bloodPresureLow(value: Int) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: "低压 ", attributes: smallAttributes)
        attr.append(NSAttributedString(string: String(value), attributes: bigAttributes))
        attr.append(NSAttributedString(string: " mmHg", attributes: smallAttributes))
        return attr
    }
}
