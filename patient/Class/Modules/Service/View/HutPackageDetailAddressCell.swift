//
//  HutPackageDetailAddressCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/18.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageDetailAddressCell: UITableViewCell {
    
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
    let addressView = AddressShowView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension HutPackageDetailAddressCell {
    private func setUI() {
        backgroundColor = .clear
        
        addressView.hasRemark = false
        addressView.titleLabel.isHidden = true
        addressView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.addSubview(addressView)
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(-45)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-15)
        }
    }
}
