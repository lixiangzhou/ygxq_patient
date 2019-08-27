//
//  SunnyDrugOrderFailCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugOrderFailCell: UITableViewCell {
    
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
    let txtLabel = UILabel(font: .size(15), textColor: .c3)
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugOrderFailCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.text = "失败原因"
        contentView.addSubview(titleView)
        
        contentView.addSubview(txtLabel)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.bottom.right.equalTo(-15)
        }
    }
}
