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
    private var accountField = InputFieldView.commonFieldView(leftImage: nil, placeholder: "请输入手机号", leftSpacing: 5, rightSpacing: 5)
    private var (codeField, codeBtn, timeLabel) = InputFieldView.codeFieldView(leftImage: nil, placeholder: "请输入验证码", leftSpacing: 5, rightSpacing: 5)
    private let loginBtn = UIButton(title: "登录", font: .boldSize(16), titleColor: .black, backgroundColor: .blue, target: self, action: #selector(loginAction))
    private var viewModel = LoginViewModel()
}

// MARK: - UI
extension LoginController {
    private func setUI() {
        let loginTitleLine = view.zz_add(subview: UIView())
        loginTitleLine.backgroundColor = .lightGray
        let loginTitleLabel = view.zz_add(subview: UILabel(text: "验证码登录", font: .size(20), textColor: .black)) as! UILabel
        
        accountField.inputLengthLimit = 11
        accountField.keyboardType = .numberPad
        
        codeBtn.setTitleColor(.c3, for: .normal)
        codeBtn.setTitleColor(.lightGray, for: .disabled)
        
        codeBtn.isEnabled = false
        
        codeField.inputLengthLimit = 6
        codeField.keyboardType = .numberPad
        
        loginBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        loginBtn.setTitleColor(.white, for: .disabled)
        loginBtn.isEnabled = false
        loginBtn.backgroundColor = UIColor.lightGray
        
        let thirdLoginTitle = view.zz_add(subview: UILabel(text: "第三方登录", font: .size(12), textColor: .c6))
        let wxLoginBtn = UIButton(imageName: "", target: self, action: #selector(wxLoginAction))
        
        view.addSubview(accountField)
        view.addSubview(codeField)
        view.addSubview(loginBtn)
        view.addSubview(wxLoginBtn)
        
        loginTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(120)
            make.left.equalTo(20)
        }
        
        loginTitleLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(loginTitleLabel)
            make.height.equalTo(5)
        }
        
        accountField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(64)
            make.right.equalTo(-20)
            make.height.equalTo(45)
        }
        
        codeField.snp.makeConstraints { (make) in
            make.top.equalTo(accountField.snp.bottom).offset(10)
            make.left.right.equalTo(accountField)
            make.height.equalTo(accountField)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeField.snp.bottom).offset(30)
            make.left.right.equalTo(accountField)
            make.height.equalTo(45)
        }
        
        thirdLoginTitle.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        wxLoginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(thirdLoginTitle.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(44)
        }
    }
    
    private func setBinding() {
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.timeLabel.text = "60秒"
            var count = 60
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
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
        
        codeBtn.reactive.isEnabled <~ accountField.valueChangedSignal.map { $0.count == 11 }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.viewModel.getCode(self.accountField.text!)
        }
        
        let loginEnabledSignal = accountField.valueChangedSignal.map { $0.count == 11 }.and(codeField.valueChangedSignal.map { $0.count == 6 })
        loginBtn.reactive.isEnabled <~ loginEnabledSignal
        loginBtn.reactive.backgroundColor <~ loginEnabledSignal.map { $0 ? UIColor.blue : UIColor.lightGray }
    }
}

// MARK: - Action
extension LoginController {
    @objc private func loginAction() {
        print("loginAction")
    }
    
    @objc private func wxLoginAction() {
        print("wxLoginAction")
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

