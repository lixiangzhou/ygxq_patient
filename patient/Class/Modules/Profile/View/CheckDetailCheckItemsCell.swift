//
//  CheckDetailCheckItemsCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CheckDetailCheckItemsCell: UITableViewCell {
    
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
    let itemsView = FourColumnView()
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension CheckDetailCheckItemsCell {
    private func setUI() {
        itemsView.config = FourColumnViewConfig(c1: 0.3, c2: 0.25, c3: 0.25, c4: 0.2, c1Title: "检查项目", c2Title: "结果", c3Title: "参考值", c4Title: "单位")
        itemsView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        itemsView.zz_setCorner(radius: 5, masksToBounds: true)
        
        contentView.addSubview(itemsView)
        
        itemsView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.bottom.equalTo(-15)
        }
    }
}

// MARK: - Action
extension CheckDetailCheckItemsCell {
    
}

// MARK: - Helper
extension CheckDetailCheckItemsCell {
    
}

// MARK: - Other
extension CheckDetailCheckItemsCell {
    
}

// MARK: - Public
extension CheckDetailCheckItemsCell {
    
}
