//
//  FUVistExamListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class FUVistExamListCell: UITableViewCell {
    
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
    let titleLabel = UILabel(font: .size(17), textColor: .c3)
    let statusLabel = UILabel(font: .size(15), textAlignment: .center)
    // MARK: - Private Property
    
}

// MARK: - UI
extension FUVistExamListCell {
    private func setUI() {
        backgroundColor = .cf0efef
        let containerView = contentView.zz_add(subview: UIView())
        containerView.backgroundColor = .cf
        containerView.zz_setCorner(radius: 8, masksToBounds: true)
        
        statusLabel.zz_setCorner(radius: 14, masksToBounds: true)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(statusLabel)
        let arrowView = containerView.zz_add(subview: UIImageView.defaultRightArrow())
        arrowView.sizeToFit()
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-5)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(statusLabel.snp.left).offset(-10)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowView.snp.left).offset(-10)
            make.width.equalTo(65)
            make.height.equalTo(28)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowView.zz_size)
        }
    }
}

// MARK: - Action
extension FUVistExamListCell {
    
}

// MARK: - Helper
extension FUVistExamListCell {
    
}

// MARK: - Other
extension FUVistExamListCell {
    
}

// MARK: - Public
extension FUVistExamListCell {
    
}
