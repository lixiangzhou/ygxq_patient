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
    let moreBtn = ZZImagePositionButton(title: "更多", font: .size(14), titleColor: .c6, imageName: "home_more", hilightedImageName: "home_more", imgPosition: .right)
    let textLabel = UILabel(font: .size(16), textColor: .c3)
    let btn = UIButton(font: .size(16), titleColor: .c00cece)
    let contentView = UIView()
    let emptyLabel = UILabel(text: "暂无任务提醒", font: .size(16), textColor: .c9, textAlignment: .center)
    private let titleLabel = UILabel(text: "任务提醒", font: .boldSize(18), textColor: .c3)
    
    var showEmpty: Bool = false {
        didSet {
            contentView.isHidden = showEmpty
            emptyLabel.isHidden = !showEmpty
            moreBtn.isHidden = showEmpty
            
            if showEmpty {
                contentView.removeFromSuperview()
                
                addSubview(emptyLabel)
                emptyLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(15)
                    make.left.equalTo(15)
                    make.height.equalTo(40)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-15)
                }
            } else {
                emptyLabel.removeFromSuperview()
                
                addSubview(contentView)
                contentView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(15)
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-15)
                }
            }
        }
    }
    
    var btnClosure: (() -> Void)?
    var moreClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HomeHeaderTaskView {
    private func setUI() {
        backgroundColor = .cf
        
        addSubview(titleLabel)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        addSubview(moreBtn)
        
        let iconView = contentView.zz_add(subview: UIImageView(image: UIImage(named: "home_task")))
        contentView.addSubview(textLabel)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btn.zz_setBorder(color: .c00cece, width: 0.5)
        btn.zz_setCorner(radius: 5, masksToBounds: true)
        contentView.addSubview(btn)
        contentView.isHidden = true
        
        addSubview(contentView)
        addSubview(emptyLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(titleLabel)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(55)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(15)
            make.right.equalToSuperview()
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.height.equalTo(40)
            make.right.equalTo(-15)
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
