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
                    self.loginCode(mobile: mobile, code: code).startWithValues { (resp) in
                        observer.send(value: BoolString(resp))
                        observer.sendCompleted()
                    }
                } else {
                    observer.send(value: BoolString(resp))
                    observer.sendCompleted()
                }
            }
        }
    }
    
    func verifyCodeAndRegister(mobile: String, code: String, password: String, inviter: String) -> SignalProducer<BoolString, NoError> {
        return SignalProducer<BoolString, NoError> { observer, _ in
            self.verifyCode(mobile: mobile, code: code).startWithValues { (resp) in
                if resp.isSuccess {
                    self.register(mobile: mobile, password: password, inviter: inviter).startWithValues({ (resp) in
                        observer.send(value: BoolString(resp))
                        observer.sendCompleted()
                    })
                } else {
                    observer.send(value: BoolString(resp))
                    observer.sendCompleted()
                }
            }
        }
    }
    
    func verifyCodeAndForgetPwd(mobile: String, code: String, password: String) -> SignalProducer<BoolString, NoError> {
        return SignalProducer<BoolString, NoError> { observer, _ in
            self.verifyCode(mobile: mobile, code: code).startWithValues { (resp) in
                if resp.isSuccess {
                    self.forgetPwd(mobile: mobile, password: password).startWithValues({ (resp) in
                        observer.send(value: resp)
                        observer.sendCompleted()
                    })
                } else {
                    observer.send(value: BoolString(resp))
                    observer.sendCompleted()
                }
            }
        }
    }
    
    func loginCode(mobile: String, code: String) -> SignalProducer<ResponseModel<PatientInfoModel>, NoError> {
        return UserApi.loginCode(mobile: mobile, code: code).rac_response(PatientInfoModel.self).on { (resp) in
            if let patientModel = resp.content {
                patientInfoProperty.value = patientModel
            }
        }
    }
    
    func loginPwd(mobile: String, password: String) -> SignalProducer<ResponseModel<PatientInfoModel>, NoError> {
        return UserApi.loginPwd(mobile: mobile, password: password).rac_response(PatientInfoModel.self).on { (resp) in
            if let patientModel = resp.content {
                patientInfoProperty.value = patientModel
            }
        }
    }
    
    func register(mobile: String, password: String, inviter: String) -> SignalProducer<ResponseModel<PatientInfoModel>, NoError> {
        return UserApi.register(mobile: mobile, password: password, invister: inviter).rac_response(PatientInfoModel.self).on { (resp) in
            if let patientModel = resp.content {
                patientInfoProperty.value = patientModel
            }
        }
    }
    
    func forgetPwd(mobile: String, password: String) -> SignalProducer<BoolString, NoError> {
        return UserApi.forgetPwd(mobile: mobile, password: password).rac_response(String.self).map { BoolString($0) }
    }
    
    
    func getCode(_ type: AuthApi.CodeType, mobile: String) {
        AuthApi.getCode(type: type, mobile: mobile).rac_response(None.self).startWithValues { (resp) in
            if resp.resultcode == 200 {
                HUD.show(toast: "验证码已发送成功，请注意查收！")
            } else {
                HUD.show(toast: resp.resultmsg ?? "验证码发送失败！")
            }
        }
    }
    
    func verifyCode(mobile: String, code: String) -> SignalProducer<ResponseModel<String>, NoError> {
        return AuthApi.verifyCode(mobile: mobile, code: code).rac_response(String.self)
    }
}
