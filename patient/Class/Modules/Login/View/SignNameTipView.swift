//
//  SignNameTipView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SignNameTipView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let msgLabel = LinkedLabel(text: "您好，注册阳光客户端需要您签字同意我们的《\(appService)》，点击可查看详情。", font: .size(15), textColor: .c6)
    var confirmClosure: ((UIImage?) -> Void)?
    var cancelClosure: (() -> Void)?

    let imgView = UIImageView()
    
    // MARK: - Private Property
    private var nameImage: UIImage?
    
}

// MARK: - UI
extension SignNameTipView {
    private func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.zz_setCorner(radius: 5, masksToBounds: true)
        addSubview(contentView)
        
        let tipTitleLabel = UILabel(text: "温馨提示", font: .boldSize(17), textColor: .c3)
        contentView.addSubview(tipTitleLabel)
        
        contentView.addSubview(msgLabel)
        
        let panelLabel = UILabel(text: "请输入您的真实姓名", font: .size(20), textAlignment: .center)
        panelLabel.zz_setCorner(radius: 5, masksToBounds: true)
        panelLabel.isUserInteractionEnabled = true
        panelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDrawPanel)))
        contentView.addSubview(panelLabel)
        
        contentView.addSubview(imgView)
        
        let cancelBtn = UIButton(title: "取消", font: .size(18), titleColor: .c9, backgroundColor: .cf5f5f5, target: self, action: #selector(hide))
        let confirmBtn = UIButton(title: "确定", font: .size(18), titleColor: .white, backgroundColor: .c407cec, target: self, action: #selector(confirmAction))
        
        contentView.addSubview(cancelBtn)
        contentView.addSubview(confirmBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        tipTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
        }
        
        msgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(tipTitleLabel.snp.bottom).offset(15)
            make.right.equalTo(-15)
        }
        
        panelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(msgLabel.snp.bottom).offset(15)
            make.left.right.equalTo(msgLabel)
            make.height.equalTo(125)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(panelLabel)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(panelLabel.snp.bottom).offset(15)
            make.left.bottom.equalToSuperview()
            make.height.equalTo(45)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(cancelBtn.snp.right)
            make.height.width.equalTo(cancelBtn)
        }
    }
}

// MARK: - Action
extension SignNameTipView {
    @objc private func confirmAction() {
        hide()
        confirmClosure?(self.nameImage)
    }
    
    override func hide() {
        super.hide()
        cancelClosure?()
    }
    
    @objc private func showDrawPanel(_ tap: UITapGestureRecognizer) {
        let dv = DrawableView()
        dv.panel.placeholder = "请输入您的真实姓名"
        dv.confirmClosure = { [weak self] _, image in
            self?.nameImage = image
            self?.imgView.image = image
        }
        dv.showHorizontal()
    }
}
