//
//  PayBottomView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PayBottomView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 50))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let descLabel = UILabel(text: "合计金额：", font: .size(15), textColor: .c3)
    let priceLabel = UILabel(text: "", font: .size(15), textColor: .cf25555)
    let payBtn = UIButton(title: "去支付", font: .boldSize(16), titleColor: .cf, backgroundColor: .cf25555)
    var payClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension PayBottomView {
    private func setUI() {
        backgroundColor = .cf
        
        payBtn.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        
        addSubview(descLabel)
        addSubview(priceLabel)
        addSubview(payBtn)
        
        let topLine = zz_add(subview: UIView())
        topLine.backgroundColor = .cdcdcdc
        
        addBottomLine()
        
        descLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(priceLabel.snp.left)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(payBtn.snp.left).offset(-10)
        }
        
        payBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(110)
        }
        
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

// MARK: - Action
extension PayBottomView {
    @objc private func payAction() {
        payClosure?()
    }
}

// MARK: - Helper
extension PayBottomView {
    
}

// MARK: - Other
extension PayBottomView {
    
}

// MARK: - Public
extension PayBottomView {
    
}
