//
//  SystemMsgViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SystemMsgViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[MsgModel]>([MsgModel]())
    
    var hasUnRead: Bool {
        for m in dataSourceProperty.value {
            if m.isLook == "N" {
                return true
            }
        }
        return false
    }
    
    func getData() {
        CommonApi.pushMsgs(uid: patientId).rac_responseModel([MsgModel].self).skipNil().startWithValues { [weak self] (models) in
            self?.dataSourceProperty.value = models
        }
    }
    
    func setAllReaded() {
        CommonApi.setAllReaded(uid: patientId).rac_response(String.self).map { BoolString($0) }.startWithValues { [weak self] (result) in
            guard let self = self else { return }
            HUD.showError(result)
            if result.isSuccess {
                self.getData()
            }
        }
    }
    
    func selectModel(_ model: MsgModel) {
        if model.isLook == "N" {
            CommonApi.setReaded(uid: model.id).rac_response(String.self).map { BoolString($0) }.startWithValues { [weak self] (result) in
                guard let self = self else { return }
                HUD.showError(result)
                if result.isSuccess {
                    var models = self.dataSourceProperty.value
                    let idx = models.firstIndex { $0.id == model.id }
                    if let idx = idx {
                        var m = model
                        m.isLook = "Y"
                        models.replaceSubrange(idx...idx, with: [m])
                        self.dataSourceProperty.value = models
                    }
                }
            }
        }
    }
}
