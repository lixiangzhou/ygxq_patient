//
//  InvoiceSelectCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class InvoiceSelectCell: UITableViewCell {
    
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
    let selectBtn = UIButton(imageName: "pay_unsel", selectedImageName: "pay_sel")
    let orderNoLabel = UILabel(font: .size(14), textColor: .c6)
    let timeLabel = UILabel(font: .size(14), textColor: .c6)
    let nameLabel = UILabel(font: .size(16), textColor: .c3, numOfLines: 1)
    let priceLabel = UILabel(font: .size(14), textColor: .cf25555)
    
    var selectClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension InvoiceSelectCell {
    private func setUI() {
        backgroundColor = .cf
        
        selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        
        let containerView = contentView.zz_add(subview: UIView())
        containerView.backgroundColor = .cf
        containerView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        containerView.zz_setCorner(radius: 8, masksToBounds: true)
        contentView.addSubview(selectBtn)
        
        containerView.addSubview(orderNoLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        
        selectBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(20)
            make.top.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.centerY.equalTo(selectBtn)
            make.left.equalTo(selectBtn.snp.right).offset(10)
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

// MARK: - Action
extension InvoiceSelectCell {
    @objc private func selectAction() {
        selectClosure?()
    }
}
