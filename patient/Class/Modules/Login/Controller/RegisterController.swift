//
//  RegisterController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class RegisterController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.transparency)
        setBackImage("login_back")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private var mobileField = InputFieldView.commonFieldView(leftImage: UIImage(named: "login_account"), placeholder: "请输入您的账号", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var (codeField, codeBtn, timeLabel) = InputFieldView.codeFieldView(leftImage: UIImage(named: "login_pwd"), text: "验证码", placeholder: "请输入验证码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var pwdField = InputFieldView.eyeFieldView(leftImage: UIImage(named: "login_pwd"), placeholder: "请输入您的密码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var inviteCodeField = InputFieldView.commonFieldView(leftImage: UIImage(named: "login_invite"), placeholder: "请输入邀请码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private let nextBtn = UIButton(title: "下一步", font: .boldSize(18), titleColor: .cf, target: self, action: #selector(nextAction))
    
    private let aggreeBtn = UIButton(imageName: "login_agree_unsel", selectedImageName: "login_agree_sel", target: self, action: #selector(agreeAction))
    private let protocolLabel = LinkedLabel(text: "同意并接受《阳光客户端服务协议》", font: .size(13), textColor: .c6)
    
    private let viewModel = LoginViewModel()
}

// MARK: - UI
extension RegisterController {
    override func setUI() {
        couldShowLogin = false
        
        let iconView = UIImageView(image: UIImage(named: "login_logo"))
        view.addSubview(iconView)
        
        let titleLabel = UILabel(text: "注册", font: .boldSize(17), textColor: .c3)
        view.addSubview(titleLabel)
        
        mobileField.inputLengthLimit = 11
        mobileField.keyboardType = .numberPad
        mobileField.zz_setCorner(radius: 22.5, masksToBounds: true)
        mobileField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        mobileField.leftViewSize = CGSize(width: 25, height: 20)
        
        codeBtn.setTitleColor(.c407cec, for: .normal)
        codeBtn.setTitleColor(.c9, for: .disabled)
        codeBtn.isEnabled = false
        
        codeField.inputLengthLimit = 6
        codeField.keyboardType = .numberPad
        codeField.zz_setCorner(radius: 22.5, masksToBounds: true)
        codeField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        codeField.leftViewSize = CGSize(width: 25, height: 20)
        
        pwdField.inputLengthLimit = 20
        pwdField.zz_setCorner(radius: 22.5, masksToBounds: true)
        pwdField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        pwdField.leftViewSize = CGSize(width: 25, height: 20)
        pwdField.isSecureTextEntry = false
        
        inviteCodeField.inputLengthLimit = 6
        inviteCodeField.keyboardType = .numberPad
        inviteCodeField.zz_setCorner(radius: 22.5, masksToBounds: true)
        inviteCodeField.zz_setBorder(color: UIColor.c205cca, width: 0.5)
        inviteCodeField.leftViewSize = CGSize(width: 25, height: 20)
        let inviteTipLabel = UILabel(text: "选填", font: .size(14), textColor: .c9)
        inviteTipLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
        inviteCodeField.rightView.addSubview(inviteTipLabel)
        inviteCodeField.rightViewSize = CGSize(width: 30, height: 15)
        
        nextBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = UIColor.cdcdcdc
        
        aggreeBtn.isSelected = true
        protocolLabel.addLinks([(string: "《阳光客户端服务协议》", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { _ in
            print("haha")
        })])
        
        
        view.addSubview(mobileField)
        view.addSubview(codeField)
        view.addSubview(pwdField)
        view.addSubview(inviteCodeField)
        view.addSubview(nextBtn)
        view.addSubview(aggreeBtn)
        view.addSubview(protocolLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(75)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        mobileField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(45)
        }
        
        codeField.snp.makeConstraints { (make) in
            make.top.equalTo(mobileField.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileField)
        }
        
        pwdField.snp.makeConstraints { (make) in
            make.top.equalTo(codeField.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileField)
        }
        
        inviteCodeField.snp.makeConstraints { (make) in
            make.top.equalTo(pwdField.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileField)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(inviteCodeField.snp.bottom).offset(25)
            make.left.right.equalTo(mobileField)
            make.height.equalTo(50)
        }
        
        aggreeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nextBtn)
            make.centerY.equalTo(protocolLabel)
            make.width.height.equalTo(15)
        }
        
        protocolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nextBtn.snp.bottom).offset(20)
            make.left.equalTo(aggreeBtn.snp.right).offset(5)
        }
    }
    
    override func setBinding() {
        
        let mobileEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(mobileField.textField.reactive.continuousTextValues.map { $0.count == 11 })
        let codeEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(codeField.textField.reactive.continuousTextValues.map { $0.count == 6 })
        let passwordEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(pwdField.textField.reactive.continuousTextValues.map { $0.count >= 6 })
        let aggreeEnabledSignal = SignalProducer<Bool, NoError>(value: true).concat(aggreeBtn.reactive.controlEvents(.touchUpInside).map { $0.isSelected })
        
        let nextEnabledSignal = mobileEnabledSignal.and(codeEnabledSignal).and(passwordEnabledSignal).and(aggreeEnabledSignal)
        
        nextBtn.reactive.isEnabled <~ nextEnabledSignal
        nextBtn.reactive.backgroundColor <~ nextEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.getCode(.forRegister, mobile: self.mobileField.text!)
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
extension RegisterController {
    @objc private func nextAction() {
        viewModel.verifyCodeAndRegister(mobile: mobileField.text!, code: codeField.text!, password: pwdField.text!, inviter: inviteCodeField.text ?? "").startWithValues { (result) in
            if result.isSuccess {
                
            } else {
                HUD.show(result)
            }
        }
    }
    
    @objc private func agreeAction() {
        aggreeBtn.isSelected = !aggreeBtn.isSelected
    }
}

// MARK: - Network
extension RegisterController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension RegisterController {
    
}

// MARK: - Other
extension RegisterController {
    
}

// MARK: - Public
extension RegisterController {
    
}

