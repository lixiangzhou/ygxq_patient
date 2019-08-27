//
//  HomeHeaderCaseView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHeaderCaseView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var uploadClosure: (() -> Void)?
    var lookClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HomeHeaderCaseView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleLabel = zz_add(subview: UILabel(text: "我的病例", font: .boldSize(18), textColor: .c3)) as! UILabel
        let subTitleLabel = zz_add(subview: UILabel(text: "为您整理专业、完整的病历资料", font: .size(13), textColor: .c9))
        
        let uploadBtn = zz_add(subview: UIButton(title: " 上传", font: .size(15), titleColor: .c6, imageName: "home_upload", hilightedImageName: "home_upload", target: self, action: #selector(uploadAction))) as! UIButton
        let lookBtn = zz_add(subview: UIButton(title: " 查看", font: .size(15), titleColor: .c6, imageName: "home_look", hilightedImageName: "home_look", target: self, action: #selector(lookAction))) as! UIButton
        
        uploadBtn.zz_setCorner(radius: 5, masksToBounds: true)
        uploadBtn.zz_setBorder(color: .c407cec, width: 0.5)
        
        lookBtn.zz_setCorner(radius: 5, masksToBounds: true)
        lookBtn.zz_setBorder(color: .cffa84c, width: 0.5)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.bottom.equalTo(titleLabel)
        }
        
        uploadBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.bottom.equalTo(-15)
            make.width.equalTo(135)
            make.height.equalTo(39)
        }
        
        lookBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.bottom.equalTo(-15)
            make.width.equalTo(135)
            make.height.equalTo(39)
        }
    }
}

// MARK: - Action
extension HomeHeaderCaseView {
    @objc private func uploadAction() {
        uploadClosure?()
    }
    
    @objc private func lookAction() {
        lookClosure?()
    }
}
