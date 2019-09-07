//
//  InvoiceContentCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class InvoiceContentCell: UITableViewCell {
    
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
    let orderNoLabel = UILabel(font: .size(14), textColor: .c6)
    let timeLabel = UILabel(font: .size(14), textColor: .c6)
    let nameLabel = UILabel(font: .size(16), textColor: .c3, numOfLines: 1)
    let priceLabel = UILabel(font: .size(14), textColor: .cf25555)
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension InvoiceContentCell {
    private func setUI() {
        backgroundColor = .cf
        
        let containerView = contentView.zz_add(subview: UIView())
        containerView.backgroundColor = .cf
        containerView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        containerView.zz_setCorner(radius: 8, masksToBounds: true)
        
        containerView.addSubview(orderNoLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-6)
        }
        
        orderNoLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNoLabel)
            make.right.equalTo(-15)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.left.equalTo(orderNoLabel)
            make.right.equalTo(priceLabel.snp.left).offset(-10)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.right.equalTo(timeLabel)
            make.height.equalTo(ceil(priceLabel.font.pointSize))
            make.width.equalTo(40)
        }
    }
}
