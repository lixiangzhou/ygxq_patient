//
//  PwdChangeController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/26.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PwdChangeController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "修改密码"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    let viewModel = PwdChangeViewModel()
    
    // MARK: - Private Property
    private let pwdView = TextLeftRightFieldView()
    private let newPwdView = TextLeftRightFieldView()
    private let newPwdView2 = TextLeftRightFieldView()
    
    private let btn = UIButton(title: "修改密码", font: .boldSize(18), titleColor: .cf, backgroundColor: .cdcdcdc)
}

// MARK: - UI
extension PwdChangeController {
    override func setUI() {
        let contentView = view.zz_add(subview: UIView())
        contentView.backgroundColor = .cf
        
        pwdView.leftLabel.text = "原密码"
        pwdView.config = TextLeftRightFieldViewConfig(rightFont: .size(16), rightLimit: 20, hasBottomLine: true, bottomLineLeftPadding: 15)
        pwdView.rightField.isSecureTextEntry = true
        pwdView.rightField.textAlignment = .right
        pwdView.rightField.placeHolderString = "请输入原密码"
        
        newPwdView.leftLabel.text = "新密码"
        newPwdView.config = TextLeftRightFieldViewConfig(rightFont: .size(16), rightLimit: 20, hasBottomLine: true, bottomLineLeftPadding: 15)
        newPwdView.rightField.isSecureTextEntry = true
        newPwdView.rightField.textAlignment = .right
        newPwdView.rightField.placeHolderString = "请输入新密码"
        
        newPwdView2.leftLabel.text = "确认新密码"
        newPwdView2.config = TextLeftRightFieldViewConfig(rightFont: .size(16), rightLimit: 20, hasBottomLine: false)
        newPwdView2.rightField.isSecureTextEntry = true
        newPwdView2.rightField.textAlignment = .right
        newPwdView2.rightField.placeHolderString = "请再次确认新密码"
        
        btn.addTarget(self, action: #selector(changeAction), for: .touchUpInside)
        
        contentView.addSubview(pwdView)
        contentView.addSubview(newPwdView)
        contentView.addSubview(newPwdView2)
        
        btn.zz_setCorner(radius: 5, masksToBounds: true)
        btn.isEnabled = false
        view.addSubview(btn)
        
        contentView.snp.makeConstraints { (make) in
            make.topOffsetFrom(self)
            make.right.left.equalToSuperview()
        }
        
        pwdView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        newPwdView.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom)
            make.left.right.height.equalTo(pwdView)
        }
        
        newPwdView2.snp.makeConstraints { (make) in
            make.top.equalTo(newPwdView.snp.bottom)
            make.left.right.height.equalTo(pwdView)
            make.bottom.equalToSuperview()
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(45)
        }
    }
    
    override func setBinding() {
        let passwardEnabledSignal = pwdView.rightField.reactive.continuousTextValues.map { $0.count >= 6 }
        let passwardEnabledSignal2 = newPwdView.rightField.reactive.continuousTextValues.map { $0.count >= 6 }
        let passwardEnabledSignal3 = newPwdView2.rightField.reactive.continuousTextValues.map { $0.count >= 6 }
        
        let pwdEquableSignal = newPwdView.rightField.reactive.continuousTextValues.combineLatest(with: newPwdView2.rightField.reactive.continuousTextValues).map { $0 == $1 }
        
        let enabledSignal = passwardEnabledSignal.and(passwardEnabledSignal2).and(passwardEnabledSignal3).and(pwdEquableSignal)
        
        btn.reactive.isEnabled <~ enabledSignal
        btn.reactive.backgroundColor <~ enabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        
        viewModel.changePwdResultProperty.signal.observeValues { [weak self] (_) in
            guard let self = self else { return }
            UIAlertController.zz_show(fromController: self, style: .alert, message: "密码修改成功，请重新登录...", actions: [UIAlertAction(title: "确定", style: .default, handler: { (_) in
                patientInfoProperty.value = nil
            })], completion: nil)
        }
    }
    
    private func addField(placeholder: String, hasLine: Bool = true) -> UITextField {
        let field = UITextField()
        field.placeHolderString = placeholder
        field.textColor = .c3
        if hasLine {
            field.addBottomLine()
        }
        return field
    }
}

// MARK: - Action
extension PwdChangeController {
    @objc private func changeAction() {
        viewModel.changePwd(pwdView.rightField.text!, newPwd: newPwdView.rightField.text!)
    }
}
