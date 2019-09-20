//
//  HutPackageTimeBuyDetailCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageTimeBuyDetailCell: UITableViewCell {
    
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
    let txtLabel = UILabel(font: .size(16), textColor: .c3)
    
    // MARK: - Private Property
}

// MARK: - UI
extension HutPackageTimeBuyDetailCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let whiteView = contentView.zz_add(subview: UIView())
        whiteView.zz_setCorner(radius: 6, masksToBounds: true)
        whiteView.backgroundColor = .cf
        
        let titleLabel = whiteView.zz_add(subview: UILabel(text: "服务详情", font: .boldSize(17), textColor: .c3))
        whiteView.addSubview(txtLabel)
        
        whiteView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.right.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(-15)
        }
    }
}
