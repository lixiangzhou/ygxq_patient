//
//  HealthDataCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/8.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(17), textColor: .c3)
    let dataLabel = UILabel()
    let timeLabel = UILabel(font: .size(12), textColor: .c6)
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        contentView.backgroundColor = .cf
        contentView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        
        iconView.contentMode = .center
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(timeLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(65)
            make.bottom.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(2)
            make.centerY.equalToSuperview()
        }
        
        dataLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(105)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
}

