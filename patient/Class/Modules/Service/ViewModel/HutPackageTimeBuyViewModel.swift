//
//  HutPackageTimeBuyViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HutPackageTimeBuyViewModel: BaseViewModel {
    let hutModelProperty = MutableProperty<SunShineHutModel?>(nil)
    
    let dataSourceProperty = MutableProperty<[RowModel]>([])
    
    var countProperty = MutableProperty<Int>(1)
    
    override init() {
        super.init()
        
        hutModelProperty.producer.skipNil().startWithValues { [weak self] (model) in
            var dataSource = [RowModel]()
            
            let attrString = NSMutableAttributedString(string: "￥", attributes: [NSAttributedString.Key.font: UIFont.size(13)])
            
            let priceString = String(format: "%.2f", model.serPrice)
            if let idx = priceString.firstIndex(of: ".") {
                attrString.append(NSAttributedString(string: "\(priceString[..<idx])", attributes: [NSAttributedString.Key.font: UIFont.boldSize(16)]))
                attrString.append(NSAttributedString(string: "\(priceString[idx...])", attributes: [NSAttributedString.Key.font: UIFont.size(13)]))
            } else {
                attrString.append(NSAttributedString(string: priceString, attributes: [NSAttributedString.Key.font: UIFont.boldSize(13)]))
            }
            
            dataSource.append(.outline(name: model.serName, price: attrString))
            
            var detailString = ""
            for (idx, detail) in model.serDetailList.enumerated() {
                detailString += "\(idx + 1).\(detail)"
                if idx < model.serDetailList.count - 1 {
                    detailString += "\n"
                }
            }
            
            dataSource.append(.detail(txt: detailString))
            dataSource.append(.tip)
            
            self?.dataSourceProperty.value = dataSource
        }
    }
    
    func getOrder(_ completion: @escaping (Int?) -> Void) {
        guard let model = hutModelProperty.value else { return }
        let params: [String: Any] = [
            "price": model.serPrice,
            "serCode": model.serCode,
            "serName": model.serName,
            "puid": patientId,
            "surplusNum": countProperty.value
        ]
        ServiceApi.addSerSunshineHut(params: params).rac_response(Int.self).startWithValues { (resp) in
            HUD.showError(BoolString(resp))
            completion(resp.content)
        }
    }
}

extension HutPackageTimeBuyViewModel {
    enum RowModel {
        case outline(name: String, price: NSAttributedString)
        case detail(txt: String)
        case tip
    }
}
