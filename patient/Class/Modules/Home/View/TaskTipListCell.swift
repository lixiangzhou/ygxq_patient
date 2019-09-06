//
//  TaskTipListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/5.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class TaskTipListCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let timeLabel = UILabel(font: .size(15), textColor: .c6)
    let txtLabel = UILabel(font: .size(15), textColor: .c3)
    let btn = UIButton(font: .size(15), titleColor: .c00cece)
    var btnClosure: (() -> Void)?
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension TaskTipListCell {
    private func setUI() {
        btn.zz_setBorder(color: .c00cece, width: 0.5)
        btn.zz_setCorner(radius: 5, masksToBounds: true)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(txtLabel)
        contentView.addSubview(btn)
        contentView.addBottomLine()
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(15)
            make.left.equalTo(timeLabel)
            make.right.equalTo(-15)
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(txtLabel.snp.bottom).offset(10)
            make.right.equalTo(txtLabel)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.bottom.equalTo(-10)
        }
    }
}

// MARK: - Action
extension TaskTipListCell {
    @objc private func btnAction() {
        btnClosure?()
    }
}
