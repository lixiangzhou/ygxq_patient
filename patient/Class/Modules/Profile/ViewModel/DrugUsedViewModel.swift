//
//  DrugUsedViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class DrugUsedViewModel: BaseViewModel {
    struct GroupModel {
        var title: String
        var open: Bool
        var list: [RowModel]
    }
    
    enum RowModel {
        case drug(DrugModel)
        case advice(String)
    }
    
    let dataSourceProperty: MutableProperty<[GroupModel]> = MutableProperty([])
    
    func getData() {
        SunnyDrugApi.usedDrugs(pid: patientId).rac_responseModel(Dictionary<String, Any>.self).startWithValues { [weak self] dict in
            if let dict = dict {
                let keys = dict.keys.sorted().reversed()
                var array = [GroupModel]()
                for (idx, key) in keys.enumerated() {
                    if let list = [DrugModel].deserialize(from: dict[key] as? NSArray) as? [DrugModel] {
                        var drugs = [RowModel]()
                        for model in list {
                            drugs.append(.drug(model))
                        }
                        if let advice = list.last?.doctorAdvice, !advice.isEmpty {
                            drugs.append(.advice(advice))
                        }
                        let group = GroupModel(title: key, open: idx == 0, list: drugs)
                        array.append(group)
                    }
                }
                
                self?.dataSourceProperty.value = array
            } else {
                self?.dataSourceProperty.value = []
            }
        }
    }
    
    func getConfig(_ title: String) -> TextLeftGrowTextRightViewConfig {
        return TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, leftWidth: title.zz_size(withLimitWidth: 100, fontSize: 15).width, leftFont: .size(15), rightTopPadding: 15, rightBottomPadding: 15, rightFont: .size(15), rightAlignment: .left, leftToRightMargin: 0)
    }
}
