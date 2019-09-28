//
//  HomeHeaderCaseView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
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
        
        let titleLabel = zz_add(subview: UILabel(text: "我的病历", font: .boldSize(19), textColor: .c3)) as! UILabel
        let subTitleLabel = zz_add(subview: UILabel(text: "为您整理专业、完整的病历资料", font: .size(15), textColor: .c6))
        
        let uploadView = addItemView(img: "home_upload", title: "上传", color: .c407cec, action: #selector(uploadAction))
        
        let lookView = addItemView(img: "home_look", title: "查看", color: .cffa84c, action: #selector(lookAction))
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.bottom.equalTo(titleLabel)
        }
        
        uploadView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.bottom.equalTo(-15)
            make.width.equalTo(140)
            make.height.equalTo(45)
        }
        
        lookView.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.width.height.bottom.equalTo(uploadView)
        }
    }
    
    private func addItemView(img: String, title: String, color: UIColor, action: Selector) -> UIView {
        let view = zz_add(subview: UIView())
        let innerView = view.zz_add(subview: UIView())
        let iconView = innerView.zz_add(subview: UIImageView(image: UIImage(named: img)))
        iconView.contentMode = .scaleAspectFit
        let titleLabel = innerView.zz_add(subview: UILabel(text: title, font: .size(18), textColor: .c6))
        
        view.zz_setCorner(radius: 5, masksToBounds: true)
        view.zz_setBorder(color: color, width: 1)
        
        innerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.height.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(5)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        
        return view
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
