//
//  LoginController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

enum LoginType: Int {
    case password
    case code
}

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
    private var mobileField = InputFieldView.commonFieldView(leftImage: UIImage(named: "login_account"), placeholder: "请输入您的账号", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var pwdField = InputFieldView.eyeFieldView(leftImage: UIImage(named: "login_pwd"), placeholder: "请输入您的密码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var (codeField, codeBtn, timeLabel) = InputFieldView.codeFieldView(leftImage: UIImage(named: "login_pwd"), text: "验证码", placeholder: "请输入验证码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private let loginBtn = UIButton(title: "登录", font: .boldSize(18), titleColor: .cf, target: self, action: #selector(loginAction))
    private var loginTypeProperty = MutableProperty(LoginType.password)
    
    private let viewModel = LoginViewModel()
}

// MARK: - UI
extension LoginController {
    override func setUI() {
        let iconView = UIImageView(image: UIImage(named: "login_logo"))
        view.addSubview(iconView)
        
        let contentView = UIView()
        view.addSubview(contentView)
        
        pwdLoginBtn = UIButton(title: "密码登录", font: .boldSize(16), titleColor: .c9)
        pwdLoginBtn.setTitleColor(.c3, for: .disabled)
        pwdLoginBtn.tag = LoginType.password.rawValue
        contentView.addSubview(pwdLoginBtn)
        
        codeLoginBtn = UIButton(title: "验证码登录", font: .boldSize(16), titleColor: .c9)
        codeLoginBtn.setTitleColor(.c3, for: .disabled)
        codeLoginBtn.tag = LoginType.code.rawValue
        contentView.addSubview(codeLoginBtn)
        
        mobileField.inputLengthLimit = 11
        mobileField.keyboardType = .numberPad
        mobileField.zz_setCorner(radius: 22.5, masksToBounds: true)
        mobileField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        mobileField.leftViewSize = CGSize(width: 25, height: 20)
//        mobileField.layer.shadowOffset = CGSize(width: 6, height: 6)
//        mobileField.layer.shadowOpacity = 0.15
//        mobileField.layer.shadowColor = UIColor.c205cca.cgColor
//        mobileField.layer.shadowRadius = 22.5
        
        
        pwdField.inputLengthLimit = 20
        pwdField.zz_setCorner(radius: 22.5, masksToBounds: true)
        pwdField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        pwdField.leftViewSize = CGSize(width: 25, height: 20)
        pwdField.isSecureTextEntry = false
        
        codeBtn.setTitleColor(.c407cec, for: .normal)
        codeBtn.setTitleColor(.c9, for: .disabled)
        codeBtn.isEnabled = false
        
        codeField.inputLengthLimit = 6
        codeField.keyboardType = .numberPad
        codeField.zz_setCorner(radius: 22.5, masksToBounds: true)
        codeField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        codeField.leftViewSize = CGSize(width: 25, height: 20)
        
        contentView.addSubview(mobileField)
        contentView.addSubview(pwdField)
        contentView.addSubview(codeField)
        
        loginBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        loginBtn.isEnabled = false
        loginBtn.backgroundColor = UIColor.cdcdcdc
        contentView.addSubview(loginBtn)
        
        let forgetPwdBtn = UIButton(title: "忘记密码？", font: .size(14), titleColor: .c9, target: self, action: #selector(forgetPwdAction))
        let toRegisterBtn = UIButton(title: "去注册", font: .size(14), titleColor: .c9, target: self, action: #selector(toRegisterAction))
        contentView.addSubview(forgetPwdBtn)
        contentView.addSubview(toRegisterBtn)
        
        let bottomBgView = UIImageView(image: UIImage(named: "login_bottom"))
        view.addSubview(bottomBgView)
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(40)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        pwdLoginBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(20)
        }
        
        codeLoginBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(-20)
        }
        
        mobileField.snp.makeConstraints { (make) in
            make.top.equalTo(pwdLoginBtn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        pwdField.snp.makeConstraints { (make) in
            make.top.equalTo(mobileField.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileField)
            make.height.equalTo(mobileField)
        }
        
        codeField.snp.makeConstraints { (make) in
            make.edges.equalTo(pwdField)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdField.snp.bottom).offset(25)
            make.left.right.equalTo(pwdField)
            make.height.equalTo(50)
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
        
        bottomBgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(loginBtn.snp.bottom).offset(50)
        }
    }
    
    override func setBinding() {
        loginTypeProperty <~ pwdLoginBtn.reactive.controlEvents(.touchUpInside).map { LoginType(rawValue: $0.tag)! }
        loginTypeProperty <~ codeLoginBtn.reactive.controlEvents(.touchUpInside).map { LoginType(rawValue: $0.tag)! }
        
        mobileField.reactive.makeBindingTarget { (view, text) in
            view.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.c9])
        } <~ loginTypeProperty.map { $0 == .password ? "请输入您的账号" : "请输入手机号码" }
        
        pwdLoginBtn.reactive.isEnabled <~ loginTypeProperty.map { $0 != .password }
        codeLoginBtn.reactive.isEnabled <~ loginTypeProperty.map { $0 != .code }
        
        pwdField.reactive.isHidden <~ loginTypeProperty.map { $0 != .password }
        codeField.reactive.isHidden <~ loginTypeProperty.map { $0 != .code }
        
        let mobileEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(mobileField.textField.reactive.continuousTextValues.map { $0.count == 11 })
        let passwardEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(pwdField.textField.reactive.continuousTextValues.map { $0.count >= 6 })
        let codeEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(codeField.textField.reactive.continuousTextValues.map { $0.count == 6 })
        
        let pwdLoginEnabledSignal = mobileEnabledSignal.and(passwardEnabledSignal)
        let codeLoginEnabledSignal = mobileEnabledSignal.and(codeEnabledSignal)
        
        let loginEnabledSignal = pwdLoginEnabledSignal.or(codeLoginEnabledSignal)
        
        loginBtn.reactive.isEnabled <~ loginEnabledSignal
        loginBtn.reactive.backgroundColor <~ loginEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.getCode(.forLogin, mobile: self.mobileField.text!)
            self.timeLabel.text = "60秒"
            var count = 60
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
                guard let self = self else { timer.invalidate(); return }
                count -= 1
                if count < 0 {
                    self.timeLabel.isHidden = true
                    self.codeBtn.isHidden = false
                    timer.invalidate()
                } else {
                    self.timeLabel.text = String(format: "%2d秒", count)
                }
            })
        }

        codeBtn.reactive.isEnabled <~ mobileField.valueChangedSignal.map { $0.count == 11 }

    }
}

// MARK: - Action
extension LoginController {
    @objc private func loginAction() {
        switch loginTypeProperty.value {
        case .password:
            viewModel.loginPwd(mobile: mobileField.text!, password: pwdField.text!).map { BoolString($0) }.startWithValues { (result) in
                if result.isSuccess {
                    
                } else {
                    HUD.show(result)
                }
            }
        case .code:
            viewModel.verifyCodeAndLogin(mobile: mobileField.text!, code: codeField.text!).startWithValues { (result) in
                if result.isSuccess {
                    
                } else {
                    HUD.show(result)
                }
            }
        }
    }
    
    @objc private func forgetPwdAction() {
        print("forgetPwdAction")
    }
    
    @objc private func toRegisterAction() {
        push(RegisterController())
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
}

// MARK: - Other
extension LoginController {
    
}

// MARK: - Public
extension LoginController {
    
}

