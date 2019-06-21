//
//  LoginViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class LoginViewModel: BaseViewModel {
    
    func verifyCodeAndLogin(mobile: String, code: String) -> SignalProducer<BoolString, NoError> {
        return SignalProducer<BoolString, NoError> { observer, _ in
            self.verifyCode(mobile: mobile, code: code).startWithValues { (resp) in
                if resp.isSuccess {
                    self.login(mobile: mobile, code: code).startWithValues { (resp) in
                        observer.send(value: BoolString(resp))
                        observer.sendCompleted()
                    }
                } else {
                    observer.send(value: BoolString(resp))
                    
                }
            }
        }
    }
    
    func login(mobile: String, code: String) -> SignalProducer<ResponseModel<PatientInfoModel>, NoError> {
        return UserApi.loginCode(mobile: mobile, code: code).rac_response(PatientInfoModel.self).on { (resp) in
            if let patientModel = resp.content {
                patientInfoProperty.value = patientModel
                loginObserver.send(value: true)
            } else {
                loginObserver.send(value: false)
            }
        }
    }
    
    func getCode(_ mobile: String) {
        AuthApi.getCode(type: .forLogin, mobile: mobile).rac_response(None.self).startWithValues { (resp) in
            if resp.resultcode == 200 {
                HUD.show(toast: "验证码已发送成功，请注意查收！")
            } else {
                HUD.show(toast: resp.resultmsg ?? "验证码发送失败！")
            }
        }
    }
    
    func verifyCode(mobile: String, code: String) -> SignalProducer<ResponseModel<None>, NoError> {
        return AuthApi.verifyCode(mobile: mobile, code: code).rac_response(None.self)
    }
}
