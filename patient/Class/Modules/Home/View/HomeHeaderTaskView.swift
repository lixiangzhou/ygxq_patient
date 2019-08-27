//
//  HomeHeaderTaskView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHeaderTaskView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let textLabel = UILabel(font: .size(16), textColor: .c3)
    let btn = UIButton(font: .size(18), titleColor: .c407cec)
    
    var btnClosure: (() -> Void)?
    var moreClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HomeHeaderTaskView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleLabel = zz_add(subview: UILabel(text: "任务提醒", font: .boldSize(18), textColor: .c3)) as! UILabel
        let moreBtn = ZZImagePositionButton(title: "更多", font: .size(14), titleColor: .c6, imageName: "home_more", hilightedImageName: "home_more", target: self, action: #selector(moreAction), imgPosition: .right)
        addSubview(moreBtn)
        
        let iconView = zz_add(subview: UIImageView(image: UIImage(named: "home_task")))
        addSubview(textLabel)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btn.zz_setBorder(color: .c407cec, width: 0.5)
        btn.zz_setCorner(radius: 5, masksToBounds: true)
        addSubview(btn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(titleLabel)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(titleLabel)
            make.width.height.equalTo(55)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(15)
            make.right.equalTo(-15)
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.right.equalTo(textLabel)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.bottom.equalTo(-15)
        }
    }
}

// MARK: - Action
extension HomeHeaderTaskView {
    @objc private func moreAction() {
        moreClosure?()
    }
    
    @objc private func btnAction() {
        btnClosure?()
    }
}
