//
//  GetRealNameTipView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/10.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class GetRealNameTipView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var confirmClosure: ((UIImage?) -> Void)?
    // MARK: - Private Property
    private var nameImage: UIImage?
}

// MARK: - UI
extension GetRealNameTipView {
    private func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.zz_setCorner(radius: 5, masksToBounds: true)
        addSubview(contentView)
        
        let tipTitleLabel = UILabel(text: "温馨提示", font: .boldSize(17), textColor: .c3)
        contentView.addSubview(tipTitleLabel)
        
        let msgLabel = LinkedLabel(text: "您好，注册阳光客户端需要您签字同意我们的《阳光客户端服务协议》，点击可查看详情。", font: .size(15), textColor: .c6)
        msgLabel.addLinks([(string: "《阳光客户端服务协议》", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { _ in
            print("haha")
        })])
        contentView.addSubview(msgLabel)
        
        let panelLabel = UILabel(text: "请输入您的真实姓名", font: .size(20), textAlignment: .center)
        panelLabel.zz_setCorner(radius: 5, masksToBounds: true)
        panelLabel.isUserInteractionEnabled = true
        panelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDrawPanel)))
        contentView.addSubview(panelLabel)
        
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
extension GetRealNameTipView {
    @objc private func confirmAction() {
        hide()
        confirmClosure?(self.nameImage)
    }
    
    @objc private func showDrawPanel(_ tap: UITapGestureRecognizer) {
        let dv = DrawableView()
        dv.panel.placeholder = "请输入您的真实姓名"
        dv.confirmClosure = { [weak self] _, image in
            self?.nameImage = image
        }
        dv.show()
    }
}
