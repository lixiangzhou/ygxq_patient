//
//  ConsultListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ConsultListCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(16), textColor: .c6)
    let timeLabel = UILabel(font: .size(16), textColor: .c6)
    let descLabel = UILabel(font: .size(16), textColor: .c3, numOfLines: 3)
    let lookBtn = UIButton(title: "查看", font: .boldSize(16), titleColor: .cffa84c)
    
    var lookClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension ConsultListCell {
    private func setUI() {
        let topView = contentView.zz_add(subview: UIView())
        topView.addSubview(nameLabel)
        topView.addSubview(timeLabel)
        topView.addBottomLine(left: 15, right: 15)
        
        let midView = contentView.zz_add(subview: UIView())
        midView.addSubview(descLabel)
        midView.addBottomLine(left: 15, right: 15)
        
        let bottomView = contentView.zz_add(subview: UIView())
        lookBtn.zz_setBorder(color: .cffa84c, width: 1)
        lookBtn.zz_setCorner(radius: 15, masksToBounds: true)
        lookBtn.addTarget(self, action: #selector(lookAction), for: .touchUpInside)
        bottomView.addSubview(lookBtn)
        
        let sepView = contentView.addBottomLine(color: .cf0efef, height: 10)
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
        
        midView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(midView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sepView.snp.top)
            make.height.equalTo(40)
        }
        
        lookBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 90, height: 30))
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
    }
}

// MARK: - Action
extension ConsultListCell {
    @objc private func lookAction() {
        lookClosure?()
    }
}
