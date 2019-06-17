//
//  MineHeaderView.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class MineHeaderView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let iconView = UIImageView()
    let nameLabel = UILabel(text: "登录 / 注册", font: .boldSize(18), textColor: .white)
    
    var tapClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension MineHeaderView {
    private func setUI() {
        addSubview(iconView)
        addSubview(nameLabel)
        
        iconView.zz_setCorner(radius: 40, masksToBounds: true)
        iconView.zz_setBorder(color: .white, width: 3)
        iconView.isUserInteractionEnabled = true
        nameLabel.isUserInteractionEnabled = true
        
        iconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-10)
            make.width.height.equalTo(80)
        }
    }
}

// MARK: - Action
extension MineHeaderView {
    @objc private func tapAction() {
        
    }
}

