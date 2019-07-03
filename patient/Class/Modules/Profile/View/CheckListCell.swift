//
//  CheckListCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(16), textColor: .c3)
    let typeLabel = UILabel(font: .boldSize(14), textColor: .cff9a21, textAlignment: .center)
    // MARK: - Private Property
    
}

// MARK: - UI
extension CheckListCell {
    private func setUI() {
        typeLabel.backgroundColor = .cffebd3
        typeLabel.zz_setCorner(radius: 3, masksToBounds: true)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        
        let arrowView = contentView.zz_add(subview: UIImageView(image: UIImage(named: "common_arrow_right")))
        
        contentView.addBottomLine(left: 15, right: 15)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.right.lessThanOrEqualTo(-20)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 45, height: 20))
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.left.equalTo(typeLabel.snp.right).offset(10)
        }
    }
}

// MARK: - Action
extension CheckListCell {
    
}

// MARK: - Helper
extension CheckListCell {
    
}

// MARK: - Other
extension CheckListCell {
    
}

// MARK: - Public
extension CheckListCell {
    
}
