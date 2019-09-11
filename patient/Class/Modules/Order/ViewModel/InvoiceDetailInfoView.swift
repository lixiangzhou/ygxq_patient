//
//  InvoiceDetailInfoView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class InvoiceDetailInfoView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let stateLabel = UILabel(font: .boldSize(17), textColor: .cf)
    let finishTimeLabel = UILabel(font: .size(16), textColor: .cf)
    
    let titleView = TextLeftGrowTextRightView()
    let idNoView = TextLeftRightView()
    let amountView = TextLeftRightView()
    let createTimeView = TextLeftRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension InvoiceDetailInfoView {
    private func setUI() {
        backgroundColor = .cf0efef
        let bgView = zz_add(subview: UIImageView(image: UIImage(named: "")))
        bgView.zz_setCorner(radius: 8, masksToBounds: true)
        bgView.backgroundColor = .c407cec
        
        let descLabel = bgView.zz_add(subview: UILabel(text: "发票状态和完成时间", font: .size(16), textColor: .cf))
        bgView.addSubview(stateLabel)
        bgView.addSubview(finishTimeLabel)
        
        let contentView = zz_add(subview: UIView())
        contentView.backgroundColor = .cf
        
        
        titleView.config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, leftWidth: 100, leftFont: .size(15), leftTextColor: .c6, rightTopPadding: 15, rightBottomPadding: 15, rightFont: .size(15), rightTextColor: .c3)
        idNoView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c3)
        amountView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .cf25555)
        createTimeView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c3, hasBottomLine: false)
        
        titleView.leftLabel.text = "发票抬头"
        idNoView.leftLabel.text = "纳税人识别号"
        amountView.leftLabel.text = "发票金额"
        createTimeView.leftLabel.text = "申请时间"
        
        contentView.addSubview(titleView)
        contentView.addSubview(idNoView)
        contentView.addSubview(amountView)
        contentView.addSubview(createTimeView)
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        stateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-15)
        }
        
        finishTimeLabel.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-15)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        idNoView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        amountView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(50)
            make.left.right.height.equalTo(idNoView)
        }
        
        createTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(amountView.snp.bottom)
            make.left.right.height.equalTo(idNoView)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension InvoiceDetailInfoView {
    
}

// MARK: - Helper
extension InvoiceDetailInfoView {
    
}

// MARK: - Other
extension InvoiceDetailInfoView {
    
}

// MARK: - Public
extension InvoiceDetailInfoView {
    
}
