//
//  FUVisitPlanViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class FUVisitPlanViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[FUVisitModel]>([])
    func getData() {
        FLPApi.queryFlpDetails(pid: patientId).rac_responseModel([FUVisitModel].self).startWithValues { [weak self] (models) in
            self?.dataSourceProperty.value = models ?? []
        }
    }
    
    func getImgs(_ model: FUVisitModel) -> [String] {
        var imgs = [String]()
        for dict in model.imgs {
            imgs.append(dict.values.first!)
        }
        return imgs
    }
}
