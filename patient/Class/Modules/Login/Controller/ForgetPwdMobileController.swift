//
//  ForgetPwdMobileController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class ForgetPwdMobileController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "忘记密码"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.c3]
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
    private let mobileView = InputFieldView.commonFieldView(leftImage: nil, placeholder: "请输入手机号码", leftSpacing: 15, rightSpacing: 15, bottomLineColor: .clear)
    private let nextBtn = UIButton(title: "下一步", font: .boldSize(18), titleColor: .cf, target: self, action: #selector(nextAction))
}

// MARK: - UI
extension ForgetPwdMobileController {
    override func setUI() {
        let tipLabel = UILabel(text: "请输入您的手机号", font: .boldSize(16), textColor: .c3)
        view.addSubview(tipLabel)
        
        mobileView.leftViewSize = .zero
        mobileView.leftPadding = 0
        mobileView.left2InputViewPadding = 0
        mobileView.inputLengthLimit = 11
        let leftView = UILabel(text: "+86", font: .size(15), textColor: .c3, textAlignment: .center)
        leftView.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        mobileView.textField.leftView = leftView
        mobileView.textField.leftViewMode = .always
        mobileView.keyboardType = .numberPad
        view.addSubview(mobileView)
        mobileView.addBg("login_field_bg")
        
        nextBtn.zz_setCorner(radius: 22.5, masksToBounds: true)
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = UIColor.cdcdcdc
        view.addSubview(nextBtn)
        
        addLoginBottomView()
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(45)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom).offset(25)
            make.left.right.equalTo(mobileView)
            make.height.equalTo(50)
        }
    }
    
    override func setBinding() {
        let nextEnabledSignal = mobileView.textField.reactive.continuousTextValues.map { $0.count == 11 }
        nextBtn.reactive.isEnabled <~ nextEnabledSignal
        nextBtn.reactive.backgroundColor <~ nextEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
    }
}

// MARK: - Action
extension ForgetPwdMobileController {
    @objc private func nextAction() {
        let vc = ForgetPwdController()
        vc.couldShowLogin = false
        vc.mobile = mobileView.text
        push(vc)
    }
}
