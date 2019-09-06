//
//  ForgetPwdController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class ForgetPwdController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "忘记密码"
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if fromLogin {
            setNavigationStyle(.whiteBg)
            setBackImage("login_back")
        }
    }

    // MARK: - Public Property
    var mobile: String!
    var fromLogin = true
    // MARK: - Private Property
    private var (codeView, codeBtn, timeLabel) = InputFieldView.codeFieldView(leftImage: UIImage(named: "login_msg"), text: "验证码", placeholder: "请输入验证码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var pwdView = InputFieldView.eyeFieldView(leftImage: UIImage(named: "login_pwd"), placeholder: "密码长度6-20位", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    
    private let confirmBtn = UIButton(title: "确定", font: .boldSize(18), titleColor: .cf, target: self, action: #selector(confirmAction))
    private let viewModel = LoginViewModel()
}

// MARK: - UI
extension ForgetPwdController {
    override func setUI() {
        if fromLogin {
            view.backgroundColor = .cf
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.c3]
        }
        
        let tipLabel = UILabel(text: "验证码已发送到您的手机号\(mobile.mobileSecrectString)", font: .size(14), textColor: .c3)
        view.addSubview(tipLabel)
        
        codeView.inputLengthLimit = 6
        codeView.keyboardType = .numberPad
        codeView.leftViewSize = CGSize(width: 25, height: 20)
        codeView.addShadowView("login_field_bg")
        
        pwdView.inputLengthLimit = 20
        pwdView.leftViewSize = CGSize(width: 25, height: 20)
        pwdView.addShadowView("login_field_bg")
        
        confirmBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        confirmBtn.isEnabled = false
        confirmBtn.backgroundColor = UIColor.cdcdcdc
        
        view.addSubview(codeView)
        view.addSubview(pwdView)
        view.addSubview(confirmBtn)

        if fromLogin {        
            addLoginBottomView()
        }
        
        tipLabel.snp.makeConstraints { (make) in
            if fromLogin {
                make.top.equalTo(40)
            } else {
                make.topOffsetFrom(self, 40)
            }
            make.centerX.equalToSuperview()
        }
        
        codeView.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(45)
        }
        
        pwdView.snp.makeConstraints { (make) in
            make.top.equalTo(codeView.snp.bottom).offset(15)
            make.left.right.height.equalTo(codeView)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom).offset(25)
            make.left.right.equalTo(codeView)
            make.height.equalTo(50)
        }
    }
    
    override func setBinding() {
        let passwardEnabledSignal = pwdView.textField.reactive.continuousTextValues.map { $0.count >= 6 }
        let codeEnabledSignal = codeView.textField.reactive.continuousTextValues.map { $0.count == 6 }
        
        let confirmEnabledSignal = passwardEnabledSignal.and(codeEnabledSignal)
        
        confirmBtn.reactive.isEnabled <~ confirmEnabledSignal
        confirmBtn.reactive.backgroundColor <~ confirmEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.getCode(.forModifyPwd, mobile: self.mobile!)
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
        codeBtn.sendActions(for: .touchUpInside)
    }
}

// MARK: - Action
extension ForgetPwdController {
    @objc private func confirmAction() {
        viewModel.verifyCodeAndForgetPwd(mobile: mobile, code: codeView.text!, password: pwdView.text!).startWithValues { [weak self] (result) in
            HUD.show(result)
            guard let self = self else { return }
            if self.fromLogin {
                if result.isSuccess {
                    DispatchQueue.main.zz_after(1) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                self.popToViewController(SettingController.zz_className)
            }
        }
    }
}
