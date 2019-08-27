//
//  SunnyDrugOrderPatientInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//Copyright © 2019 sphr. All rights reserved.
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
    let nameView = TextLeftGrowTextRightView()
    let mobileView = TextLeftGrowTextRightView()
    let addressView = TextLeftGrowTextRightView()
    let remarkView = TextLeftGrowTextRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugOrderPatientInfoCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.text = "个人基本信息"
        contentView.addSubview(titleView)
        
        nameView.config = normalConfig()
        mobileView.config = normalConfig()
        addressView.config = normalConfig()
        remarkView.config = lastConfig()
        
        nameView.leftLabel.text = "姓名"
        mobileView.leftLabel.text = "手机号"
        addressView.leftLabel.text = "收货地址"
        remarkView.leftLabel.text = "备注"
        
        contentView.addSubview(nameView)
        contentView.addSubview(mobileView)
        contentView.addSubview(addressView)
        contentView.addSubview(remarkView)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(45)
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
        return TextLeftGrowTextRightViewConfig(leftTopPadding: 13.5, leftBottomPadding: 13.5, leftWidth: 90, leftFont: .size(15), leftTextColor: .c6, rightTopPadding: 13.5, rightBottomPadding: 13.5, rightFont: .size(15), rightTextColor: .c3)
    }
    
    private func lastConfig() -> TextLeftGrowTextRightViewConfig {
        return TextLeftGrowTextRightViewConfig(leftTopPadding: 13.5, leftBottomPadding: 13.5, leftWidth: 90, leftFont: .size(15), leftTextColor: .c6, rightTopPadding: 13.5, rightBottomPadding: 13.5, rightFont: .size(15), rightTextColor: .c3, hasBottomLine: false)
    }
}
