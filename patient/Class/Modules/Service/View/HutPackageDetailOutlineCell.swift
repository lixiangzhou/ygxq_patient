//
//  HutPackageDetailOutlineCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageDetailOutlineCell: UITableViewCell {
    
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
    let titleLabel = UILabel(font: .boldSize(17), textColor: .c3)
    let timeLabel = UILabel(font: .size(16), textColor: .c3)
    let featureLabel = UILabel(font: .size(16), textColor: .c3)
    // MARK: - Private Property
    
}

// MARK: - UI
extension HutPackageDetailOutlineCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let whiteView = contentView.zz_add(subview: UIView())
        whiteView.zz_setCorner(radius: 6, masksToBounds: true)
        whiteView.backgroundColor = .cf
        
        whiteView.addSubview(titleLabel)
        whiteView.addSubview(timeLabel)
        whiteView.addSubview(featureLabel)
        
        whiteView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.bottom.equalTo(-12)
            make.right.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(titleLabel)
            make.right.equalTo(-12)
        }
        
        featureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.left.right.equalTo(timeLabel)
            make.bottom.equalTo(-15)
        }
    }
}
