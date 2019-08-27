//
//  LongServiceListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/17.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LongServiceListCell: UITableViewCell {
    
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
    let listView = ThreeColumnView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension LongServiceListCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let view = contentView.zz_add(subview: UIView())
        view.backgroundColor = .cf
        view.zz_setCorner(radius: 8, masksToBounds: true)
        
        listView.config = ThreeColumnViewConfig(width: UIScreen.zz_width - 54, c1: 0.33, c2: 0.33, c3: 0.34, c1Title: "服务名称", c2Title: "剩余次数", c3Title: "截止日期", headerTopPadding: 15, headerBottomPadding: 15, rowTopPadding: 15, rowBottomPadding: 15)
        listView.zz_setCorner(radius: 5, masksToBounds: true)
        listView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        listView.backgroundColor = .cf
        view.addSubview(listView)
        
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-12)
        }
        
        listView.snp.makeConstraints { (make) in
            make.top.left.equalTo(12)
            make.bottom.right.equalTo(-12)
        }
    }
}
