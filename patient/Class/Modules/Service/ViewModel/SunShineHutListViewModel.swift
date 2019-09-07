//
//  SunShineHutListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunShineHutListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[SunShineHutModel]>([])
    let hasBuyECGProperty = MutableProperty<Bool>(true)
    func getData() {
        ServiceApi.querySunshineHutList.rac_responseModel([SunShineHutModel].self).startWithValues { [weak self] (value) in
            self?.dataSourceProperty.value = value ?? []
        }
    }
    
    func getPrice(_ model: SunShineHutModel) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "￥", attributes: [NSAttributedString.Key.font: UIFont.size(14)])
        
        let priceString = String(format: "%.2f", model.serPrice)
        if let idx = priceString.firstIndex(of: ".") {
            attrString.append(NSAttributedString(string: "\(priceString[...idx])", attributes: [NSAttributedString.Key.font: UIFont.boldSize(20)]))
            var unit = ""
            switch model.serCode {
            case "UTOPIA13": unit = "元/年"
            case "UTOPIA14": unit = "元/次"
            default: break
            }
            attrString.append(NSAttributedString(string: "\(priceString[idx...])\(unit)", attributes: [NSAttributedString.Key.font: UIFont.size(14)]))
        } else {
            attrString.append(NSAttributedString(string: priceString, attributes: [NSAttributedString.Key.font: UIFont.boldSize(20)]))
        }
        
        return attrString
    }
    
    func canBuy(_ model: SunShineHutModel) {
        ECGApi.isBuyECG(pid: patientId, keyword: model.serCode).rac_response(Bool.self).startWithValues { [weak self] (resp) in
             self?.hasBuyECGProperty.value = resp.content == true
        }
    }

}
