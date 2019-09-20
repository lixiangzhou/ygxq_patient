//
//  MineHeaderView.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class MineHeaderView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 180 + UIScreen.zz_statusBar_additionHeight))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let bgImageView = UIImageView(image: UIImage(named: "mine_top_bg"))
    let iconView = UIImageView(image: UIImage(named: "mine_avator_default"))
    let nameLabel = UILabel(font: .boldSize(17), textColor: .white)
    
    var tapClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension MineHeaderView {
    private func setUI() {
        addSubview(bgImageView)
        addSubview(iconView)
        addSubview(nameLabel)
        
        iconView.zz_setCorner(radius: 40, masksToBounds: true)
//        iconView.zz_setBorder(color: .white, width: 3)
        iconView.isUserInteractionEnabled = true
        nameLabel.isUserInteractionEnabled = true
        
        iconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(UIScreen.zz_statusBar_additionHeight + 50)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Action
extension MineHeaderView {
    @objc private func tapAction() {
        tapClosure?()
    }
}

