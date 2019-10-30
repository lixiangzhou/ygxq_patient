//
//  SunnyDrugOrderPatientInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugOrderPatientInfoCell: UITableViewCell {
    
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
    let nameView = LeftRightUpDownLabelView()
    let mobileView = TextLeftGrowTextRightView()
    let addressView = LeftRightUpDownLabelView()
    let remarkView = LeftRightUpDownLabelView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugOrderPatientInfoCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(17), leftTextColor: .c3)
        titleView.leftLabel.text = "个人基本信息"
        contentView.addSubview(titleView)
        
        nameView.config = .init(bottomLineLeftPadding: 15)
        mobileView.config = normalConfig()
        addressView.config = .init(bottomLineLeftPadding: 15)
        remarkView.config = .init(hasBottomLine: false)
        
        nameView.titleLabel.text = "姓名"
        mobileView.leftLabel.text = "手机号"
        addressView.titleLabel.text = "收货地址"
        remarkView.titleLabel.text = "备注"
        
        contentView.addSubview(nameView)
        contentView.addSubview(mobileView)
        contentView.addSubview(addressView)
        contentView.addSubview(remarkView)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(12)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalTo(titleView)
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.equalTo(titleView)
        }
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.left.right.equalTo(titleView)
        }
        
        remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom)
            make.left.right.equalTo(titleView)
            make.bottom.equalToSuperview()
        }
    }
    
    private func normalConfig() -> TextLeftGrowTextRightViewConfig {
        return TextLeftGrowTextRightViewConfig(leftTopPadding: 14, leftBottomPadding: 14, leftWidth: 100, leftFont: .size(16), leftTextColor: .c3, rightTopPadding: 14, rightBottomPadding: 14, rightFont: .size(16), rightTextColor: .c3, bottomLineLeftPadding: 15)
    }
}
