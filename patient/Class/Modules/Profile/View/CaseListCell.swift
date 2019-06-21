//
//  CaseListCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CaseListCell: UITableViewCell, IDCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let createTimeLabel = UILabel(font: .size(15), textColor: .c6)
    let hospitalLabel = UILabel(font: .size(16), textColor: .c3)
    let clinicTimeLabel = UILabel(font: .size(16), textColor: .c3)
    let typeLabel = UILabel(font: .boldSize(14), textColor: .cff9a21, textAlignment: .center)
}

// MARK: - UI
extension CaseListCell {
    private func setUI() {
        let topView = contentView.zz_add(subview: UIView())
        topView.addBottomLine(left: 15, right: -15)
        
        topView.addSubview(createTimeLabel)
        
        let midView = contentView.zz_add(subview: UIView())
        contentView.addBottomLine(color: .cf0efef, height: 10)
        
        typeLabel.backgroundColor = .cffebd3
        typeLabel.zz_setCorner(radius: 3, masksToBounds: true)
        
        let arrowView = midView.zz_add(subview: UIImageView(image: UIImage(named: "common_arrow_right")))
        
        midView.addSubview(hospitalLabel)
        midView.addSubview(clinicTimeLabel)
        midView.addSubview(typeLabel)
        midView.addSubview(arrowView)
        
        topView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        midView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
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
