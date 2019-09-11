//
//  PayResultViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PayResultViewModel: BaseViewModel {
    /// 支付结果页用来查询医助的
    var duid = 0
    
    let assistModelProperty = MutableProperty<DoctorAssistModel?>(nil)
    
    func getAssistData() {
        DoctorApi.assist(duid: duid).rac_responseModel(DoctorAssistModel.self).skipNil().startWithValues { [weak self] (model) in
            self?.assistModelProperty.value = model
        }
    }

}
