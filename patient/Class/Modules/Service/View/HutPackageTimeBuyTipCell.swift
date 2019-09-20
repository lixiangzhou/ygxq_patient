//
//  HutPackageTimeBuyTipCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/20.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageTimeBuyTipCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let txtLabel = UILabel(text: "退款计算方式：退款金额=总价-剩余次数的价格。", font: .size(15), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension HutPackageTimeBuyTipCell {
    private func setUI() {
        backgroundColor = .cf0efef
        contentView.addSubview(txtLabel)
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
}
