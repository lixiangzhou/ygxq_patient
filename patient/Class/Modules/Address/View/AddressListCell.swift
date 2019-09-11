//
//  AddressListCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .boldSize(16), textColor: .c3)
    let mobileLabel = UILabel(font: .boldSize(16), textColor: .c3)
    let defaultView = UILabel(text: "默认", font: .size(16), textColor: .cff9a21, textAlignment: .center)
    let addressLabel = UILabel(font: .size(16), textColor: .c3)
    
    var editClosure: (() -> Void)?
    
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension AddressListCell {
    private func setUI() {
        contentView.backgroundColor = .cf
        
        defaultView.backgroundColor = .cffebd3
        defaultView.zz_setCorner(radius: 3, masksToBounds: true)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(mobileLabel)
        contentView.addSubview(defaultView)
        contentView.addSubview(addressLabel)
        
        let editLabel = contentView.zz_add(subview: UILabel(text: "编辑", font: .size(16), textColor: .c6, textAlignment: .center))
        editLabel.isUserInteractionEnabled = true
        editLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toEditAction)))
        
        let sepLine = contentView.zz_add(subview: UIView())
        sepLine.backgroundColor = UIColor.cdcdcdc
        
        contentView.addBottomLine()
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        mobileLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(15)
        }
        
        defaultView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(mobileLabel.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 45, height: 20))
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(editLabel.snp.left).offset(-15)
            make.bottom.equalTo(-15)
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 0.5, height: 20))
            make.centerY.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(60)
            make.left.equalTo(sepLine.snp.right)
        }
        
    }
}

// MARK: - Action
extension AddressListCell {
    @objc private func toEditAction() {
        editClosure?()
    }
}

// MARK: - Helper
extension AddressListCell {
    
}

// MARK: - Other
extension AddressListCell {
    
}

// MARK: - Public
extension AddressListCell {
    
}
