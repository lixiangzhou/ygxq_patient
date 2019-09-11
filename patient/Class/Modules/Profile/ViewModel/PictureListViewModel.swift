//
//  PictureListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PictureListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[String]>([])
    var time: TimeInterval?
    /// 通过 getData 获取数据，否则从其他地方传入数据
    var getDataFromSelf = true
    
    func getData() {
        if getDataFromSelf {        
            MediaApi.queryById(pid: patientId, type: "SER_HLR", createTime: time).rac_responseModel([String: [String]].self).skipNil().startWithValues { [weak self] (value) in
                self?.dataSourceProperty.value = value.values.first ?? []
            }
        }
    }
}
