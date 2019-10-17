//
//  VideoConsultPatientInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class VideoConsultPatientInfoCell: UITableViewCell {
    
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
    let nameView = TextLeftRightView()
    let mobileView = TextLeftRightView()
    let idView = TextLeftRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension VideoConsultPatientInfoCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(17), leftTextColor: .c3)
        titleView.leftLabel.text = "个人基本信息"
        contentView.addSubview(titleView)
        
        nameView.config = TextLeftRightViewConfig(leftFont: .size(16), rightFont: .size(16), bottomLineLeftPadding: 15)
        mobileView.config = TextLeftRightViewConfig(leftFont: .size(16), rightFont: .size(16), bottomLineLeftPadding: 15)
        idView.config = TextLeftRightViewConfig(leftFont: .size(16), rightFont: .size(15), hasBottomLine: false)
        
        nameView.leftLabel.text = "姓名"
        mobileView.leftLabel.text = "手机号"
        idView.leftLabel.text = "身份证号码"
        
        contentView.addSubview(nameView)
        contentView.addSubview(mobileView)
        contentView.addSubview(idView)
        
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
            make.height.equalTo(50)
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.height.left.right.equalTo(nameView)
        }
        
        idView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.height.left.right.equalTo(nameView)
            make.bottom.equalToSuperview()
        }
    }
}
