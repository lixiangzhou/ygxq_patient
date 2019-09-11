//
//  SunnyDrugBuyIdView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugBuyIdView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    
    let picView = UIImageView(image: UIImage(named: "sunny_drug_id_upload"))
    var picClosure: (() -> Void)?
}

// MARK: - UI
extension SunnyDrugBuyIdView {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let titleLabel = UILabel(text: "请您上传身份证照片", font: .size(15), textColor: .c6)
        addSubview(titleLabel)
        
        let contentView = zz_add(subview: UIView())
        contentView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.backgroundColor = .cf
        
        let sampleBtn = contentView.zz_add(subview: UIButton(title: "示例", font: .size(14), titleColor: .c407cec, target: self, action: #selector(sampleAction)))
        
        picView.isUserInteractionEnabled = true
        picView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        contentView.addSubview(picView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(45)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
        
        picView.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.bottom.equalTo(-17)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(105)
        }
        
        sampleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
    }
}

// MARK: - Action
extension SunnyDrugBuyIdView {
    @objc private func sampleAction() {
        SunnyDrugBuyIdTipView().show()
    }
    
    @objc private func tapAction() {
        picClosure?()
    }
}
