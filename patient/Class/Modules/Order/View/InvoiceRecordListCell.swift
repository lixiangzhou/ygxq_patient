//
//  InvoiceRecordListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class InvoiceRecordListCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    
    let timeLabel = UILabel(font: .size(14), textColor: .c6)
    let statusLabel = UILabel(font: .size(16), textColor: .c3)
    let priceLabel = UILabel(font: .size(14), textColor: .cf25555)
    // MARK: - Private Property
    
}

// MARK: - UI
extension InvoiceRecordListCell {
    private func setUI() {
        backgroundColor = .cf
        
        let containerView = contentView.zz_add(subview: UIView())
        containerView.backgroundColor = .cf
        containerView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        containerView.zz_setCorner(radius: 8, masksToBounds: true)
        
        containerView.addSubview(timeLabel)
        let priceDescLabel = containerView.zz_add(subview: UILabel(text: "发票金额：", font: .size(14), textColor: .c3))
        containerView.addSubview(priceLabel)
        containerView.addSubview(statusLabel)
        let arrowView = containerView.zz_add(subview: UIImageView.defaultRightArrow())
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.left.equalTo(15)
            make.bottom.equalTo(-6)
            make.right.equalTo(-15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        priceDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.bottom.equalTo(-15)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(priceDescLabel.snp.right)
            make.bottom.equalTo(priceDescLabel)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(statusLabel.snp.right).offset(10)
            make.right.equalTo(-15)
        }
    }
}
