//
//  CaseDetailOpCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CaseDetailOpCell: UITableViewCell {
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    let titleLabel = UILabel(font: .size(16), textColor: .c6)
    let opView = FourColumnView()
    
    // MARK: - Private Properties
}

// MARK: - UI
extension CaseDetailOpCell {
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(opView)
        contentView.addBottomLine()
        
        opView.config = FourColumnViewConfig(c1: 0.25, c2: 0.25, c3: 0.25, c4: 0.25, c1Title: "部位", c2Title: "病变性质", c3Title: "狭窄程度", c4Title: "侧支")
        
        opView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        opView.zz_setCorner(radius: 5, masksToBounds: true)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(15)
            maker.left.equalTo(15)
        }
        
        opView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(15)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.bottom.equalTo(-15)
        }
    }
}
