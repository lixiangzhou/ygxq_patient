//
//  DrawableView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/10.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DrawableView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var cancelClosure: ((DrawableView) -> Void)?
    var confirmClosure: ((DrawableView, UIImage?) -> Void)?
    
    // MARK: - Private Property
    let panel = DrawablePanel()
}

// MARK: - UI
extension DrawableView {
    private func setUI() {
        addSubview(panel)
        
        let resetBtn = UIButton(title: "重签", font: .size(20), titleColor: .blue, target: self, action: #selector(resetAction))
        addSubview(resetBtn)
        
        let bottomView = zz_add(subview: UIView())
        bottomView.backgroundColor = .white
        
        let cancelBtn = UIButton(title: "取消", font: .size(20), titleColor: .c9, target: self, action: #selector(cancelAction))
        let confirmBtn = UIButton(title: "确定", font: .size(20), titleColor: .white, target: self, action: #selector(confirmAction))
        confirmBtn.backgroundColor = .blue
        
        bottomView.addSubview(cancelBtn)
        bottomView.addSubview(confirmBtn)
        
        panel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        resetBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(panel).offset(-20)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(panel.snp.bottom)
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(cancelBtn.snp.right)
            make.width.equalTo(cancelBtn)
        }
    }
}

// MARK: - Action
extension DrawableView {
    @objc private func resetAction() {
        panel.clear()
    }
    
    @objc private func cancelAction() {
        hide()
        cancelClosure?(self)
    }
    
    @objc private func confirmAction() {
        hide()
        confirmClosure?(self, panel.getImage())
    }
}
