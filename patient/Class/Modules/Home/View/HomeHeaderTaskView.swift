//
//  HomeHeaderTaskView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
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
    let moreBtn = ZZImagePositionButton(title: "更多", font: .boldSize(17), titleColor: .c407cec, imageName: "home_more", hilightedImageName: "home_more", imgPosition: .right)
    let textLabel = UILabel(font: .size(16), textColor: .c3)
    let taskActionLabel = UILabel(text: "", font: .boldSize(17), textColor: .cff9a21)
    let contentView = UIView()
    let emptyLabel = UILabel(text: "暂无任务提醒~", font: .size(16), textColor: .c3, textAlignment: .center)
    private let titleLabel = UILabel(text: "任务提醒", font: .boldSize(19), textColor: .c3)
    
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
                    make.height.equalTo(50)
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
    
    var taskClosure: (() -> Void)?
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
        
        contentView.addSubview(textLabel)
        
        let taskActionView = contentView.zz_add(subview: UIView())
        
        let taskInnerView = taskActionView.zz_add(subview: UIView())
        taskInnerView.addSubview(taskActionLabel)
        let taskMoreView = taskInnerView.zz_add(subview: UIImageView(image: UIImage(named: "home_task_more")))
        
        taskActionView.zz_setBorder(color: .cff9a21, width: 1)
        taskActionView.zz_setCorner(radius: 15, masksToBounds: true)
        taskActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(taskAction)))
        
        contentView.addSubview(taskActionView)
        contentView.isHidden = true
        
        let emptyIconView = emptyLabel.zz_add(subview: UIImageView(image: UIImage(named: "home_task_empty")))
        
        addSubview(contentView)
        addSubview(emptyLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.bottom.equalTo(titleLabel)
            make.width.equalTo(46)
            make.height.equalTo(25)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(-15)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        taskActionView.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.bottom.equalToSuperview()
        }
        
        taskInnerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        taskActionLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        
        taskMoreView.snp.makeConstraints { (make) in
            make.left.equalTo(taskActionLabel.snp.right).offset(5)
            make.centerY.right.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalTo(12)
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(12)
            make.height.equalTo(50)
            make.right.equalTo(-12)
            make.bottom.equalTo(-15)
        }
        
        emptyIconView.sizeToFit()
        emptyIconView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.left.size.equalTo(emptyIconView.zz_size)
        }
    }
}

// MARK: - Action
extension HomeHeaderTaskView {
    @objc private func moreAction() {
        moreClosure?()
    }
    
    @objc private func taskAction() {
        taskClosure?()
    }
}
