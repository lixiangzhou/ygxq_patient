//
//  HealthDataECGBasinInfoTopView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGBasinInfoTopView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let infoLabel = UILabel(font: .size(12), textColor: .cff3a33)
    var buyClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataECGBasinInfoTopView {
    private func setUI() {
        backgroundColor = .cf0efef
        addSubview(infoLabel)
        let buyBtn = zz_add(subview: UIButton(title: "购买", font: .size(16), titleColor: .cf, backgroundColor: .cffa84c, target: self, action: #selector(buyAction)))
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(15)
            make.right.equalTo(buyBtn.snp.left).offset(-15)
        }
        
        buyBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
    }
}

// MARK: - Action
extension HealthDataECGBasinInfoTopView {
    @objc private func buyAction() {
        buyClosure?()
    }
}
