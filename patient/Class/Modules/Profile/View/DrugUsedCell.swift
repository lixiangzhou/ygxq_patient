//
//  DrugUsedCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/4.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DrugUsedCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let nameLabel = UILabel(font: .size(16), textColor: .c3)
    var specLabel: UILabel!
    var usageLabel: UILabel!
    // MARK: - Private Property
    
}

// MARK: - UI
extension DrugUsedCell {
    private func setUI() {
        let nameView = UIView()
        nameView.addSubview(nameLabel)
        nameView.addBottomLine()
        contentView.addSubview(nameView)
        
        let specView = TextLeftGrowTextRightView()
        let specTitle = "包装规格："
        specView.config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, leftWidth: specTitle.zz_size(withLimitWidth: 100, fontSize: 15).width, leftFont: .size(15), rightTopPadding: 15, rightBottomPadding: 15, rightFont: .size(15), rightAlignment: .left, leftToRightMargin: 0)
        specView.leftLabel.text = specTitle
        specLabel = specView.rightLabel
        
        let usageView = TextLeftGrowTextRightView()
        let usageTitle = "用法频率："
        usageView.config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, leftWidth: usageTitle.zz_size(withLimitWidth: 100, fontSize: 15).width, leftFont: .size(15), rightTopPadding: 15, rightBottomPadding: 15, rightFont: .size(15), rightAlignment: .left, leftToRightMargin: 0)
        usageView.leftLabel.text = usageTitle
        usageLabel = usageView.rightLabel
        
        contentView.addSubview(specView)
        contentView.addSubview(usageView)
        
        nameView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.bottom.equalTo(-15)
        }
        
        specView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        usageView.snp.makeConstraints { (make) in
            make.top.equalTo(specView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension DrugUsedCell {
    
}

// MARK: - Helper
extension DrugUsedCell {
    
}

// MARK: - Other
extension DrugUsedCell {
    
}

// MARK: - Public
extension DrugUsedCell {
    
}
