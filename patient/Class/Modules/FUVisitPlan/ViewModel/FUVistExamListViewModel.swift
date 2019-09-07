//
//  FUVistExamListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class FUVistExamListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[ExamModel]>([])
    var id = 0
    
    func getData() {
        FLPApi.queryFlpExams(id: id).rac_responseModel([ExamModel].self).startWithValues { [weak self] (models) in
            self?.dataSourceProperty.value = models ?? []
        }
    }
}
