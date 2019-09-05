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
        let bgView = zz_add(subview: UIView())
        bgView.backgroundColor = .cf
        
        addSubview(panel)
        
        let resetBtn = UIButton(title: "重签", font: .size(18), titleColor: .c407cec, target: self, action: #selector(resetAction))
        addSubview(resetBtn)
        
        let bottomView = zz_add(subview: UIView())
        bottomView.backgroundColor = .white
        
        let cancelBtn = UIButton(title: "取消", font: .size(18), titleColor: .c9, backgroundColor: .cf5f5f5, target: self, action: #selector(cancelAction))
        let confirmBtn = UIButton(title: "确定", font: .size(18), titleColor: .white, backgroundColor: .c407cec, target: self, action: #selector(confirmAction))
        
        bottomView.addSubview(cancelBtn)
        bottomView.addSubview(confirmBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        panel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.left.right.equalTo(safeAreaLayoutGuide)
            } else {
                make.top.left.right.equalToSuperview()
            }
        }
        
        resetBtn.snp.makeConstraints { (make) in
            make.right.equalTo(UIScreen.zz_iPhoneX ? -35 : -16)
            make.bottom.equalTo(panel).offset(-18)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(panel.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.left.right.equalTo(safeAreaLayoutGuide)
            } else {
                make.bottom.left.right.equalToSuperview()
            }
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
