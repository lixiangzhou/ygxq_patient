//
//  SunnyDrugOrderDrugsCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugOrderDrugsCell: UITableViewCell {
    
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
    let txtLabel = UILabel(font: .size(16), textColor: .c3)
    let priceView = TextLeftRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugOrderDrugsCell {
    private func setUI() {
        contentView.backgroundColor = .cf
        
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(17), leftTextColor: .c3)
        titleView.leftLabel.text = "购买药品"
        contentView.addSubview(titleView)
        
        let midView = contentView.zz_add(subview: UIView())
        midView.addBottomLine(left: 15)
        midView.addSubview(txtLabel)

        priceView.config = TextLeftRightViewConfig(rightFont: .size(16), rightTextColor: .c3, hasBottomLine: false)
        priceView.rightLabel.text = "总价"
        contentView.addSubview(priceView)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(12)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        midView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.bottom.equalTo(-15)
        }
        
        priceView.snp.makeConstraints { (make) in
            make.top.equalTo(midView.snp.bottom)
            make.left.right.height.equalTo(titleView)
            make.bottom.equalToSuperview()
        }
    }
}
