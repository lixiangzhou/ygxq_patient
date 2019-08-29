//
//  DoctorDetailMsgCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DoctorDetailMsgCell: UITableViewCell {
    
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
    let titleLabel = UILabel(font: .boldSize(15), textColor: .c3)
    let txtLabel = UILabel(font: .size(14), textColor: .c3)
    // MARK: - Private Property
    
}

// MARK: - UI
extension DoctorDetailMsgCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let bgView = contentView.zz_add(subview: UIView())
        bgView.zz_setCorner(radius: 5, masksToBounds: true)
        bgView.backgroundColor = .cf
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(txtLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(15)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.bottom.equalTo(-20)
        }
    }
}

// MARK: - Action
extension DoctorDetailMsgCell {
    
}

// MARK: - Helper
extension DoctorDetailMsgCell {
    
}

// MARK: - Other
extension DoctorDetailMsgCell {
    
}

// MARK: - Public
extension DoctorDetailMsgCell {
    
}
