//
//  CaseListCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CaseListCell: UITableViewCell {
    
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
    let hospitalLabel = UILabel(font: .size(16), textColor: .c3)
    let clinicTimeLabel = UILabel(font: .size(16), textColor: .c3)
    let typeLabel = UILabel(font: .boldSize(14), textColor: .cff9a21, textAlignment: .center)
    var bottomLine: UIView!
}

// MARK: - UI
extension CaseListCell {
    private func setUI() {
        typeLabel.backgroundColor = .cffebd3
        typeLabel.zz_setCorner(radius: 3, masksToBounds: true)
        
        contentView.addSubview(hospitalLabel)
        contentView.addSubview(clinicTimeLabel)
        contentView.addSubview(typeLabel)
        bottomLine = contentView.addBottomLine()
        
        let arrowView = contentView.zz_add(subview: UIImageView.defaultRightArrow())
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.lessThanOrEqualTo(typeLabel.snp.left).offset(-20)
        }
        
        clinicTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hospitalLabel.snp.bottom).offset(10)
            make.left.right.equalTo(hospitalLabel)
            make.bottom.equalTo(-15)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 45, height: 20))
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.left.equalTo(typeLabel.snp.right).offset(10)
        }
    }
}

// MARK: - Action
extension CaseListCell {
    
}

// MARK: - Helper
extension CaseListCell {
    
}

// MARK: - Other
extension CaseListCell {
    
}

// MARK: - Public
extension CaseListCell {
    
}
