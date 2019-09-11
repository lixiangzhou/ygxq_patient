//
//  UploadHistoryViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class UploadHistoryViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[Model]>([])
    func getData() {
        MediaApi.queryById(pid: patientId, type: "SER_HLR", createTime: nil).rac_responseModel([String: [String]].self).skipNil().startWithValues { [weak self] (value) in
            
            let sortedKeys = value.keys.sorted(by: { (t1, t2) -> Bool in
                return t1.zz_date(withDateFormat: "yyyy-MM-dd HH:mm:ss")! > t2.zz_date(withDateFormat: "yyyy-MM-dd HH:mm:ss")!
            })
            
            var result = [Model]()
            for k in sortedKeys {
                result.append(Model(title: k, list: value[k] ?? []))
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
