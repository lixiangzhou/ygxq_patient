//
//  UploadHistoryViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class UploadHistoryViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[Model]>([])
    func getData() {
        MediaApi.queryById(pid: patientId, type: "SER_HLR").rac_responseModel([String: [String]].self).skipNil().startWithValues { [weak self] (value) in
            var result = [Model]()
            for (k, v) in value {
                result.append(Model(title: k, list: v))
            }
            self?.dataSourceProperty.value = result
        }
    }
}

extension UploadHistoryViewModel {
    struct Model {
        let title: String
        let list: [String]
    }
}
