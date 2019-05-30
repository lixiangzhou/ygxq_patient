//
//  LoginController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LoginController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationStyle(.transparency)
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private var pwdLoginBtn: UIButton!
    private var codeLoginBtn: UIButton!
    private var accountField = InputFieldView.commonFieldView(leftImage: nil, placeholder: "请输入您的账号", leftSpacing: 5, rightSpacing: 5)
    private var pwdField = InputFieldView.eyeFieldView(leftImage: nil, placeholder: "请输入您的密码", leftSpacing: 5, rightSpacing: 5)
    private var (codeField, codeBtn) = InputFieldView.codeFieldView(leftImage: nil, text: "验证码", placeholder: "请输入验证码", leftSpacing: 5, rightSpacing: 5)
    private let loginBtn = UIButton(title: "登录", font: .boldSize(16), titleColor: .black, backgroundColor: .blue, target: self, action: #selector(loginAction))
    private var loginTypeProperty = MutableProperty(LoginType.password)
}

// MARK: - UI
extension LoginController {
    private func setUI() {
        let iconView = UIImageView(image: UIImage(named: ""))
        iconView.backgroundColor = .red
        view.addSubview(iconView)
        
        let contentView = UIView()
        view.addSubview(contentView)
        
        pwdLoginBtn = UIButton(title: "密码登录", font: .size(16), titleColor: .c6)
        pwdLoginBtn.setTitleColor(.black, for: .disabled)
        pwdLoginBtn.tag = LoginType.password.rawValue
        contentView.addSubview(pwdLoginBtn)
        
        codeLoginBtn = UIButton(title: "验证码登录", font: .size(16), titleColor: .c6)
        codeLoginBtn.setTitleColor(.black, for: .disabled)
        codeLoginBtn.tag = LoginType.code.rawValue
        contentView.addSubview(codeLoginBtn)
        
        accountField.inputLengthLimit = 11
        accountField.keyboardType = .numberPad
        
        contentView.addSubview(accountField)
        contentView.addSubview(pwdField)
        contentView.addSubview(codeField)
        
        loginBtn.setTitleColor(.white, for: .disabled)
        loginBtn.setTitleColor(.black, for: .normal)
        contentView.addSubview(loginBtn)
        
        let forgetPwdBtn = UIButton(title: "忘记密码？", font: .boldSize(14), titleColor: .black, target: self, action: #selector(forgetPwdAction))
        let toRegisterBtn = UIButton(title: "去注册", font: .boldSize(14), titleColor: .black, target: self, action: #selector(toRegisterAction))
        contentView.addSubview(forgetPwdBtn)
        contentView.addSubview(toRegisterBtn)
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(60)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        pwdLoginBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(10)
        }
        
        codeLoginBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(-10)
        }
        
        accountField.snp.makeConstraints { (make) in
            make.top.equalTo(pwdLoginBtn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        pwdField.snp.makeConstraints { (make) in
            make.top.equalTo(accountField.snp.bottom).offset(15)
            make.left.right.height.equalTo(accountField)
            make.height.equalTo(accountField)
        }
        
        codeField.snp.makeConstraints { (make) in
            make.edges.equalTo(pwdField)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdField.snp.bottom).offset(20)
            make.left.right.equalTo(pwdField)
            make.height.equalTo(40)
        }
        
        forgetPwdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(15)
            make.left.equalTo(loginBtn).offset(15)
            make.bottom.equalToSuperview()
        }
        
        toRegisterBtn.snp.makeConstraints { (make) in
            make.top.equalTo(forgetPwdBtn)
            make.right.equalTo(loginBtn).offset(-15)
        }
    }
    
    private func setBinding() {
        loginTypeProperty <~ pwdLoginBtn.reactive.controlEvents(.touchUpInside).map { LoginType(rawValue: $0.tag)! }
        loginTypeProperty <~ codeLoginBtn.reactive.controlEvents(.touchUpInside).map { LoginType(rawValue: $0.tag)! }
        
        pwdLoginBtn.reactive.isEnabled <~ loginTypeProperty.map { $0 != .password }
        codeLoginBtn.reactive.isEnabled <~ loginTypeProperty.map { $0 != .code }
        
        pwdField.reactive.isHidden <~ loginTypeProperty.map { $0 != .password }
        codeField.reactive.isHidden <~ loginTypeProperty.map { $0 != .code }
        
        codeField.textField.reactive.text <~ loginTypeProperty.map { $0 != .code ? nil : self.codeField.text }
        pwdField.textField.reactive.text <~ loginTypeProperty.map { $0 != .password ? nil : self.pwdField.text }
        
        let btnEnabledSignal = accountField.textField.reactive.continuousTextValues.map { $0.count > 0 }
            .and(pwdField.textField.reactive.continuousTextValues.map { $0.count > 0 }
                .or(codeField.textField.reactive.continuousTextValues.map { $0.count > 0 }))
            .skipRepeats()
        loginBtn.reactive.isEnabled <~ btnEnabledSignal
        loginBtn.reactive.backgroundColor <~ btnEnabledSignal.map { $0 ? UIColor.orange : UIColor.lightGray }
        
        // 触发输入框的初始状态
        accountField.textField.sendActions(for: .editingChanged)
        pwdField.textField.sendActions(for: .editingChanged)
        codeField.textField.sendActions(for: .editingChanged)
        
        pwdLoginBtn.sendActions(for: .touchUpInside)
    }
}

// MARK: - Action
extension LoginController {
    @objc private func loginAction() {
        print("loginAction")
    }
    
    @objc private func forgetPwdAction() {
        print("forgetPwdAction")
    }
    
    @objc private func toRegisterAction() {
        print("toRegisterAction")
    }
}

// MARK: - Network
extension LoginController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension LoginController {
    enum LoginType: Int {
        case password
        case code
    }
}

// MARK: - Other
extension LoginController {
    
}

// MARK: - Public
extension LoginController {
    
}

