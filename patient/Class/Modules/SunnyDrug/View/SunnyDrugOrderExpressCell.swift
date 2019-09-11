//
//  SunnyDrugOrderExpressCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugOrderExpressCell: UITableViewCell {
    
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
    let noView = TextLeftRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugOrderExpressCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView(TextLeftRightViewConfig(leftFont: .boldSize(16), leftTextColor: .c3))
        titleView.leftLabel.text = "快递信息"
        contentView.addSubview(titleView)
        
        nameView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c3, bottomLineLeftPadding: 15)
        noView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, rightFont: .size(15), rightTextColor: .c3, hasBottomLine: false)
        
        nameView.leftLabel.text = "快递公司"
        noView.leftLabel.text = "快递单号"
        
        contentView.addSubview(nameView)
        contentView.addSubview(noView)
        
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
            make.height.left.right.equalTo(titleView)
        }
        
        noView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.height.left.right.equalTo(titleView)
            make.bottom.equalToSuperview()
        }
    }
}
