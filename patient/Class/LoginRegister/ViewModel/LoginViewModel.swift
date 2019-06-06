//
//  LoginViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {
    
    func login() {
        
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
}
