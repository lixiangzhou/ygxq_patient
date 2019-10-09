//
//  DateView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DateView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let picker = UIDatePicker()
    var finishClosure: ((Date) -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension DateView {
    private func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        let toolBar = UIView()
        toolBar.backgroundColor = .cf0efef
        addSubview(toolBar)
        
        let cancelBtn = UIButton(title: "取消", font: .size(17), titleColor: .c407cec, target: self, action: #selector(hide))
        let finishBtn = UIButton(title: "完成", font: .size(17), titleColor: .c407cec, target: self, action: #selector(finishAction))
        
        toolBar.addSubview(cancelBtn)
        toolBar.addSubview(finishBtn)
        
        picker.backgroundColor = .cf
        picker.maximumDate = Date()
        addSubview(picker)
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        
        finishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        picker.snp.makeConstraints { (make) in
            make.top.equalTo(toolBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - Action
extension DateView {
    @objc private func finishAction() {
        hide()
        finishClosure?(picker.date)
    }
}
