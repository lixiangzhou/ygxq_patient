//
//  PayListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PayListCell: UITableViewCell {
    
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
    let productView = TextLeftRightView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension PayListCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .size(15), leftTextColor: .c6, hasBottomLine: false)
        titleView.leftLabel.text = "服务清单"
        
        productView.config = TextLeftRightViewConfig(leftFont: .size(17), leftTextColor: .c3, rightTextColor: .cff3a33, hasBottomLine: false)
        productView.backgroundColor = .cf
        
        contentView.addSubview(titleView)
        contentView.addSubview(productView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        productView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
    }
}
