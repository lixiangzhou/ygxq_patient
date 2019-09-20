//
//  SunShineHutListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunShineHutListCell: UITableViewCell {
    
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
    let iconView = UIImageView()
    let nameLabel = UILabel(font: .size(17), textColor: .c3, numOfLines: 2)
    let featureLabel = UILabel(font: .size(15), textColor: .c6, numOfLines: 1)
    let priceLabel = UILabel(textColor: .cff3a33)
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunShineHutListCell {
    private func setUI() {
        iconView.backgroundColor = .cf0efef
        iconView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        iconView.zz_setCorner(radius: 5, masksToBounds: true)
        
        let arrowView = UIImageView.defaultRightArrow()
        arrowView.sizeToFit()
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(featureLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(arrowView)
        contentView.addBottomLine()
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.width.height.equalTo(110)
            make.bottom.equalTo(-10)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalTo(arrowView.snp.left).offset(-5)
        }
        
        featureLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.left.equalTo(nameLabel)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(iconView)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(arrowView.zz_size)
        }
    }
}

// MARK: - Action
extension SunShineHutListCell {
    
}

// MARK: - Helper
extension SunShineHutListCell {
    
}

// MARK: - Other
extension SunShineHutListCell {
    
}

// MARK: - Public
extension SunShineHutListCell {
    
}
