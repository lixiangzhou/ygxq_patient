//
//  VideoConsultBuyPatientInfoView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class VideoConsultBuyPatientInfoView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let nameView = TextLeftRightFieldView()
    let mobileView = TextLeftRightFieldView()
    let idView = TextLeftRightFieldView()
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension VideoConsultBuyPatientInfoView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.text = "个人基本信息"
        addSubview(titleView)
        
        nameView.config = TextLeftRightFieldViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c6, rightWidth: 200, rightLimit: 100, bottomLineLeftPadding: 15)
        mobileView.config = TextLeftRightFieldViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c6, rightLimit: 11, bottomLineLeftPadding: 15)
        idView.config = TextLeftRightFieldViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c6, rightWidth: 200, rightLimit: 18, hasBottomLine: false)
        
        
        nameView.leftLabel.text = "姓名"
        nameView.rightField.placeHolderString = "请输入您的姓名"
        nameView.rightField.textAlignment = .right
        nameView.inputLimitClosure = { string in
            return string.isMatchNameInputValidate
        }
        
        mobileView.leftLabel.text = "手机号"
        mobileView.rightField.isUserInteractionEnabled = false
        mobileView.rightField.keyboardType = .numberPad
        mobileView.rightField.textAlignment = .right
        
        idView.leftLabel.text = "身份证号码"
        idView.rightField.placeHolderString = "请输入您的身份证号码"
        idView.rightField.textAlignment = .right
        idView.inputLimitClosure = { string in
            return string.isMatchIdNoInputing
        }
        
        addSubview(nameView)
        addSubview(mobileView)
        addSubview(idView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.height.right.equalTo(titleView)
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.height.right.equalTo(titleView)
        }
        
        idView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.left.height.right.equalTo(titleView)
            make.bottom.equalToSuperview()
        }
    }
}
