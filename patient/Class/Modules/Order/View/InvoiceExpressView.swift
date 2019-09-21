//
//  InvoiceExpressView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class InvoiceExpressView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let nameView = TextLeftRightView()
    let noView = TextLeftRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension InvoiceExpressView {
    private func setUI() {
        backgroundColor = .cf
        
        nameView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c3)
        noView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c3)
        let tipLabel = UILabel(text: "可通过快递公司及单号查询您的发票邮递情况", font: .size(14), textColor: .c407cec, textAlignment: .center)
        
        nameView.leftLabel.text = "快递公司"
        noView.leftLabel.text = "快递单号"
        
        addSubview(nameView)
        addSubview(noView)
        addSubview(tipLabel)
        
        nameView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        noView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noView.snp.bottom)
            make.left.right.height.equalTo(nameView)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension InvoiceExpressView {
    
}

// MARK: - Helper
extension InvoiceExpressView {
    
}

// MARK: - Other
extension InvoiceExpressView {
    
}

// MARK: - Public
extension InvoiceExpressView {
    
}
