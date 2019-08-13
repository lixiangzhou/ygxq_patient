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
        setNavigationStyle(.whiteBg)
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    private var pwdLoginBtn: UIButton!
    private var codeLoginBtn: UIButton!
    private var mobileView = InputFieldView.commonFieldView(leftImage: UIImage(named: "login_account"), placeholder: "请输入您的账号", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var pwdView = InputFieldView.eyeFieldView(leftImage: UIImage(named: "login_pwd"), placeholder: "请输入您的密码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var (codeView, codeBtn, timeLabel) = InputFieldView.codeFieldView(leftImage: UIImage(named: "login_pwd"), text: "验证码", placeholder: "请输入验证码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private let loginBtn = UIButton(title: "登录", font: .boldSize(18), titleColor: .cf, target: self, action: #selector(loginAction))
    private var loginTypeProperty = MutableProperty(LoginType.password)
    
    private let viewModel = LoginViewModel()
}

// MARK: - UI
extension LoginController {
    override func setUI() {
        couldShowLogin = false
        
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
        
        mobileView.inputLengthLimit = 11
        mobileView.keyboardType = .numberPad
        mobileView.leftViewSize = CGSize(width: 25, height: 20)
        mobileView.addShadowView("login_field_bg")
        
        pwdView.inputLengthLimit = 20
        pwdView.leftViewSize = CGSize(width: 25, height: 20)
        pwdView.isSecureTextEntry = false
        pwdView.addShadowView("login_field_bg")
        
        codeBtn.setTitleColor(.c407cec, for: .normal)
        codeBtn.setTitleColor(.c9, for: .disabled)
        codeBtn.isEnabled = false
        
        codeView.inputLengthLimit = 6
        codeView.keyboardType = .numberPad
        codeView.leftViewSize = CGSize(width: 25, height: 20)
        codeView.addShadowView("login_field_bg")
        
        contentView.addSubview(mobileView)
        contentView.addSubview(pwdView)
        contentView.addSubview(codeView)
        
        loginBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        loginBtn.isEnabled = false
        loginBtn.backgroundColor = UIColor.cdcdcdc
        contentView.addSubview(loginBtn)
        
        let forgetPwdBtn = UIButton(title: "忘记密码？", font: .size(14), titleColor: .c9, target: self, action: #selector(forgetPwdAction))
        let toRegisterBtn = UIButton(title: "去注册", font: .size(14), titleColor: .c9, target: self, action: #selector(toRegisterAction))
        contentView.addSubview(forgetPwdBtn)
        contentView.addSubview(toRegisterBtn)
        
        addLoginBottomView()
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(40)
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
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(pwdLoginBtn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        pwdView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileView)
            make.height.equalTo(mobileView)
        }
        
        codeView.snp.makeConstraints { (make) in
            make.edges.equalTo(pwdView)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom).offset(25)
            make.left.right.equalTo(pwdView)
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
    }
    
    override func setBinding() {
        loginTypeProperty <~ pwdLoginBtn.reactive.controlEvents(.touchUpInside).map { LoginType(rawValue: $0.tag)! }
        loginTypeProperty <~ codeLoginBtn.reactive.controlEvents(.touchUpInside).map { LoginType(rawValue: $0.tag)! }
        
        mobileView.reactive.makeBindingTarget { (view, text) in
            view.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.c9])
        } <~ loginTypeProperty.map { $0 == .password ? "请输入您的账号" : "请输入手机号码" }
        
        pwdLoginBtn.reactive.isEnabled <~ loginTypeProperty.map { $0 != .password }
        codeLoginBtn.reactive.isEnabled <~ loginTypeProperty.map { $0 != .code }
        
        pwdView.reactive.isHidden <~ loginTypeProperty.map { $0 != .password }
        codeView.reactive.isHidden <~ loginTypeProperty.map { $0 != .code }
        
        let mobileEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(mobileView.textField.reactive.continuousTextValues.map { $0.count == 11 })
        let passwardEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(pwdView.textField.reactive.continuousTextValues.map { $0.count >= 6 })
        let codeEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(codeView.textField.reactive.continuousTextValues.map { $0.count == 6 })
        
        let pwdLoginEnabledSignal = mobileEnabledSignal.and(passwardEnabledSignal)
        let codeLoginEnabledSignal = mobileEnabledSignal.and(codeEnabledSignal)
        
        let loginEnabledSignal = pwdLoginEnabledSignal.or(codeLoginEnabledSignal)
        
        loginBtn.reactive.isEnabled <~ loginEnabledSignal
        loginBtn.reactive.backgroundColor <~ loginEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.getCode(.forLogin, mobile: self.mobileView.text!)
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

        codeBtn.reactive.isEnabled <~ mobileView.valueChangedSignal.map { $0.count == 11 }

    }
}

// MARK: - Action
extension LoginController {
    @objc private func loginAction() {
        switch loginTypeProperty.value {
        case .password:
            viewModel.loginPwd(mobile: mobileView.text!, password: pwdView.text!).map { BoolString($0) }.startWithValues { [weak self] (result) in
                if result.isSuccess {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    HUD.show(result)
                }
            }
        case .code:
            viewModel.verifyCodeAndLogin(mobile: mobileView.text!, code: codeView.text!).startWithValues { [weak self] (result) in
                if result.isSuccess {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    HUD.show(result)
                }
            }
        }
    }
    
    @objc private func forgetPwdAction() {
        let vc = ForgetPwdMobileController()
        vc.couldShowLogin = false
        push(vc)
    }
    
    @objc private func toRegisterAction() {
        push(RegisterController())
    }
}

extension BaseController {
    
    func addLoginBottomView() {
        let bottomBgView = UIImageView(image: UIImage(named: "login_bottom"))
        view.insertSubview(bottomBgView, at: 0)
        
        bottomBgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
}
