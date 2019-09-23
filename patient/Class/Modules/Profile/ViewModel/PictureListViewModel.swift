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
    /// 通过 getData 获取数据，否则从其他地方传入数据
    var getDataFromSelf = true
    
    var type: DataFromSelfType = .history(time: nil)
    
    func getData() {
        if getDataFromSelf {
            switch type {
            case let .history(time: time):
                MediaApi.queryById(pid: patientId, type: "SER_HLR", createTime: time).rac_responseModel([String: [String]].self).startWithValues { [weak self] (value) in
                    self?.dataSourceProperty.value = value?.values.first ?? []
                }
            case let .videoOrDrugDetail(linkId: linkId, serType: serType, imgType: imgType):
                MediaApi.listAllMediasByLinkId(linkId: linkId, serType: serType, imgType: imgType).rac_responseModel([ImageModel].self).startWithValues { [weak self] (models) in
                    if let models = models {
                        var urls = [String]()
                        for m in models {
                            urls.append(m.mediaUrl)
                        }
                        self?.dataSourceProperty.value = urls
                    } else {
                        self?.dataSourceProperty.value = []
                    }
                }
            }
            
        }
    }
}

extension PictureListViewModel {
    enum DataFromSelfType {
        case history(time: TimeInterval?)
        case videoOrDrugDetail(linkId: Int, serType: String, imgType: Int)
    }
}
