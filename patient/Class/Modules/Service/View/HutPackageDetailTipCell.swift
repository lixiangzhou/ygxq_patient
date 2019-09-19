//
//  HutPackageDetailTipCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageDetailTipCell: UITableViewCell {
    
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
    let txtLabel = UILabel(text: "温馨提示\n我们将以快递的形式给您配送设备，请务必填写信息！此为医疗器械设备，购买后不支持退货退款。", font: .size(15), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension HutPackageDetailTipCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        contentView.addSubview(txtLabel)
            
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
}
