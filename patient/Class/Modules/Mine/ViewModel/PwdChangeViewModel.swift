//
//  PwdChangeViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/26.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PwdChangeViewModel: BaseViewModel {
    let changePwdResultProperty = MutableProperty<Bool>(false)
    
    func changePwd(_ pwd: String, newPwd: String) {
        UserApi.token.rac_response(String.self).startWithValues { (resp) in
            HUD.showError(BoolString(resp))
            if resp.isSuccess && resp.content != nil {
                UserApi.changePwd(uid: patientId, token: resp.content!, pwd: pwd, newPwd: newPwd).rac_response(String.self).startWithValues({ [weak self] (resp) in
                    HUD.showError(BoolString(resp))
                    if resp.isSuccess {
                        self?.changePwdResultProperty.value = true
                    }
                })
            }
        }
    }
}
