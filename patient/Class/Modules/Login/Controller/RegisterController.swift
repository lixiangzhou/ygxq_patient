//
//  RegisterController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/2.
//  Copyright © 2019 sphr. All rights reserved.
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
        
        setNavigationStyle(.whiteBg)
        setBackImage("login_back")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private var mobileView = InputFieldView.commonFieldView(leftImage: UIImage(named: "login_account"), placeholder: "请输入您的手机号码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var (codeView, codeBtn, timeLabel) = InputFieldView.codeFieldView(leftImage: UIImage(named: "login_msg"), text: "验证码", placeholder: "请输入验证码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var pwdView = InputFieldView.eyeFieldView(leftImage: UIImage(named: "login_pwd"), placeholder: "请输入您的密码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private var inviteCodeView = InputFieldView.commonFieldView(leftImage: UIImage(named: "login_invite"), placeholder: "请输入邀请码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private let nextBtn = UIButton(title: "下一步", font: .boldSize(18), titleColor: .cf, target: self, action: #selector(nextAction))
    
    private let aggreeBtn = UIButton(imageName: "login_agree_unsel", selectedImageName: "login_agree_sel", target: self, action: #selector(agreeAction))
    private let protocolLabel = LinkedLabel(text: "同意并接受《\(appService)》", font: .size(13), textColor: .c6)
    
    private let viewModel = LoginViewModel()
}

// MARK: - UI
extension RegisterController {
    override func setUI() {
        view.backgroundColor = .cf
        couldShowLogin = false
        
        let iconView = UIImageView(image: UIImage(named: "login_logo"))
        view.addSubview(iconView)
        
        let titleLabel = UILabel(text: "注册", font: .boldSize(17), textColor: .c3)
        view.addSubview(titleLabel)
        
        mobileView.inputLengthLimit = 11
        mobileView.keyboardType = .numberPad
        mobileView.leftViewSize = CGSize(width: 25, height: 20)
        mobileView.addShadowView("login_field_bg")
        
        codeBtn.setTitleColor(.c407cec, for: .normal)
        codeBtn.setTitleColor(.c9, for: .disabled)
        codeBtn.isEnabled = false
        
        codeView.inputLengthLimit = 6
        codeView.keyboardType = .numberPad
        codeView.leftViewSize = CGSize(width: 25, height: 20)
        codeView.addShadowView("login_field_bg")
        
        pwdView.inputLengthLimit = 20
        pwdView.leftViewSize = CGSize(width: 25, height: 20)
        pwdView.addShadowView("login_field_bg")
        
        inviteCodeView.inputLengthLimit = 6
        inviteCodeView.keyboardType = .numberPad
        inviteCodeView.leftViewSize = CGSize(width: 25, height: 20)
        let inviteTipLabel = UILabel(text: "选填", font: .size(14), textColor: .c9)
        inviteTipLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
        inviteCodeView.hasRightView = true
        inviteCodeView.rightView.addSubview(inviteTipLabel)
        inviteCodeView.rightViewSize = CGSize(width: 30, height: 15)
        inviteCodeView.right2InputViewPadding = 0
        inviteCodeView.addShadowView("login_field_bg")
        
        nextBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = UIColor.cdcdcdc
        
        aggreeBtn.isSelected = true
        protocolLabel.addLinks([(string: "《\(appService)》", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { [weak self] _ in
            self?.toServicePrototol()
        })])
        
        view.addSubview(mobileView)
        view.addSubview(codeView)
        view.addSubview(pwdView)
        view.addSubview(inviteCodeView)
        view.addSubview(nextBtn)
        view.addSubview(aggreeBtn)
        view.addSubview(protocolLabel)
        
        addLoginBottomView()
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(45)
        }
        
        codeView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileView)
        }
        
        pwdView.snp.makeConstraints { (make) in
            make.top.equalTo(codeView.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileView)
        }
        
        inviteCodeView.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom).offset(20)
            make.left.right.height.equalTo(mobileView)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(inviteCodeView.snp.bottom).offset(25)
            make.left.right.equalTo(mobileView)
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
        let mobileEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(mobileView.textField.reactive.continuousTextValues.map { $0.count == 11 })
        let codeEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(codeView.textField.reactive.continuousTextValues.map { $0.count == 6 })
        let passwordEnabledSignal = SignalProducer<Bool, NoError>(value: false).concat(pwdView.textField.reactive.continuousTextValues.map { $0.count >= 6 })
        let aggreeEnabledSignal = SignalProducer<Bool, NoError>(value: true).concat(aggreeBtn.reactive.controlEvents(.touchUpInside).map { $0.isSelected })
        
        let nextEnabledSignal = mobileEnabledSignal.and(codeEnabledSignal).and(passwordEnabledSignal).and(aggreeEnabledSignal)
        
        nextBtn.reactive.isEnabled <~ nextEnabledSignal
        nextBtn.reactive.backgroundColor <~ nextEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        codeBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            
            if !self.mobileView.text!.hasPrefix("1") {
                HUD.show(toast: "手机号码格式错误")
                self.timeLabel.isHidden = true
                self.codeBtn.isHidden = false
                return
            }
            self.timeLabel.isHidden = true
            self.codeBtn.isHidden = false
            self.viewModel.getCode(.forRegister, mobile: self.mobileView.text!) { isSuccess in
                if isSuccess {
                    self.timeLabel.isHidden = false
                    self.codeBtn.isHidden = true
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
            }
        }
        
        codeBtn.reactive.isEnabled <~ mobileView.valueChangedSignal.map { $0.count == 11 }
    }
}

// MARK: - Action
extension RegisterController {
    @objc private func nextAction() {
        if !mobileView.text!.hasPrefix("1") {
            HUD.show(toast: "手机号码格式错误")
            return
        }
        viewModel.verifyCodeAndRegister(mobile: mobileView.text!, code: codeView.text!, password: pwdView.text!, inviter: inviteCodeView.text ?? "").startWithValues { [weak self] (result) in
            HUD.show(result)
            if result.isSuccess {
                DispatchQueue.main.zz_after(1.5) {                
                    let vc = PersonInfoEditController()
                    vc.couldShowLogin = false
                    self?.push(vc)
                }
            }
        }
    }
    
    @objc private func agreeAction() {
        aggreeBtn.isSelected = !aggreeBtn.isSelected
    }
}
