//
//  ProfileHeaderView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ProfileHeaderView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let nameLabel = UILabel(text: " ", font: .size(19), textColor: .c3)
    let mobileLabel = UILabel(text: " ", font: .size(14), textColor: .c6)
    let sexLabel = UILabel(text: " ", font: .size(15), textColor: .c6, textAlignment: .center)
    let ageLabel = UILabel(text: " ", font: .size(15), textColor: .c6, textAlignment: .center)
    let diseaseLabel = UILabel(text: " ", font: .size(15), textColor: .c6, textAlignment: .center)
    // MARK: - Private Property
    
}

// MARK: - UI
extension ProfileHeaderView {
    private func setUI() {
        backgroundColor = .clear
        
        let topView = UIView()
        topView.backgroundColor = .cf
        addSubview(topView)
        
        topView.addSubview(nameLabel)
        topView.addSubview(mobileLabel)
        topView.addSubview(sexLabel)
        topView.addSubview(ageLabel)
        topView.addSubview(diseaseLabel)
        
        let sexDescLabel = topView.zz_add(subview: UILabel(text: "性别", font: .size(14), textColor: .c9, textAlignment: .center))
        let ageDescLabel = topView.zz_add(subview: UILabel(text: "年龄", font: .size(14), textColor: .c9, textAlignment: .center))
        let diseaseDescLabel = topView.zz_add(subview: UILabel(text: "疾病", font: .size(14), textColor: .c9, textAlignment: .center))
        
        let line1 = topView.zz_add(subview: UIView.sepLine())
        let line2 = topView.zz_add(subview: UIView.sepLine())
        
        let uploadBtn = zz_add(subview: UIButton(title: "上传资料", font: .size(15), titleColor: .c6, backgroundColor: .cf, target: self, action: #selector(uploadAction)))
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        mobileLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        let padding: CGFloat = 20
        let width = (UIScreen.zz_width - padding * 2) / 3
        
        sexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ageLabel)
            make.left.equalTo(padding)
            make.width.equalTo(width)
        }
        
        sexDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ageDescLabel)
            make.left.width.equalTo(sexLabel)
        }
        
        ageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mobileLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(width)
        }
        
        ageDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ageLabel.snp.bottom).offset(10)
            make.left.width.equalTo(ageLabel)
            make.bottom.equalTo(-20)
        }
        
        diseaseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ageLabel)
            make.right.equalTo(-padding)
            make.width.equalTo(width)
        }
        
        diseaseDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ageDescLabel)
            make.left.width.equalTo(diseaseLabel)
        }
        
        line1.snp.makeConstraints { (make) in
            make.centerY.equalTo(ageLabel.snp.bottom).offset(5)
            make.centerX.equalTo(ageLabel.snp.left)
            make.size.equalTo(CGSize(width: 1, height: 20))
        }
        
        line2.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(line1)
            make.centerX.equalTo(ageLabel.snp.right)
        }
        
        uploadBtn.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
        }
    }
}

// MARK: - Action
extension ProfileHeaderView {
    @objc private func uploadAction() {
        
    }
}

// MARK: - Helper
extension ProfileHeaderView {
    
}

// MARK: - Other
extension ProfileHeaderView {
    
}

// MARK: - Public
extension ProfileHeaderView {
    
}
