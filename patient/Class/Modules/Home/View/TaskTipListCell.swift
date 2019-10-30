//
//  TaskTipListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/5.
//  Copyright © 2019 sphr. All rights reserved.
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
    let timeLabel = UILabel(font: .size(16), textColor: .c3)
    let txtLabel = UILabel(font: .size(16), textColor: .c3)
    let btn = UIButton(font: .size(16), titleColor: .cffa84c)
    var btnClosure: (() -> Void)?
    
    // MARK: - Private Property
}

// MARK: - UI
extension TaskTipListCell {
    private func setUI() {
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        let topView = contentView.zz_add(subview: UIView())
        topView.addSubview(timeLabel)
        topView.addSubview(btn)
        let arrowView = topView.zz_add(subview: UIImageView(image: UIImage(named: "task_top_arrow")))
        arrowView.isUserInteractionEnabled = true
        arrowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnAction)))
        topView.addBottomLine()
        
        contentView.addSubview(txtLabel)
        let bottomLine = contentView.addBottomLine(color: .cf0efef, height: 10)
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(arrowView.snp.left).offset(-5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(15)
            make.left.equalTo(timeLabel)
            make.right.equalTo(-15)
            make.bottom.equalTo(bottomLine.snp.top).offset(-15)
        }
    }
}

// MARK: - Action
extension TaskTipListCell {
    @objc private func btnAction() {
        btnClosure?()
    }
}
