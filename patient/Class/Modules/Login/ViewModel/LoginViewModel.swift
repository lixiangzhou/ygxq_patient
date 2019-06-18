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
    
    func verifyCodeAndLogin(mobile: String, code: String) -> SignalProducer<Bool, NoError> {
        return SignalProducer<Bool, NoError> { observer, _ in
            self.verifyCode(mobile: mobile, code: code).startWithValues { (validateSuccess) in
                if validateSuccess {
                    self.login(mobile: mobile, code: code).startWithValues { (isSuccess) in
                        observer.send(value: isSuccess)
                        observer.sendCompleted()
                    }
                } else {
                    observer.send(value: false)
                    observer.sendCompleted()
                    HUD.show(toast: "验证码错误")
                }
            }
        }
    }
    
    func login(mobile: String, code: String) -> SignalProducer<Bool, NoError> {
        return UserApi.loginCode(mobile: mobile, code: code).rac_responseModel(PatientInfoModel.self).map { (patientModel) -> Bool in
            if let patientModel = patientModel {
                PatientManager.shared.save(patient: patientModel)
                loginObserver.send(value: true)
                return true
            } else {
                loginObserver.send(value: false)
                return false
            }
        }
    }
    
    func getCode(_ mobile: String) {
        AuthApi.getCode(type: .forLogin, mobile: mobile).rac_responseModel(String.self).startWithValues { (none) in
            if none != nil {
                HUD.show(toast: "验证码已发送成功，请注意查收！")
            } else {
                HUD.show(toast: "验证码发送失败！")
            }
        }
    }
    
    func verifyCode(mobile: String, code: String) -> SignalProducer<Bool, NoError> {
        return AuthApi.verifyCode(mobile: mobile, code: code).rac_responseModel(String.self).map { $0 != nil }
    }
}
