//
//  HealthDataMemberListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataMemberListCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(15), textColor: .c3)
    let sexLabel = UILabel(font: .size(15), textColor: .c3)
    let ageLabel = UILabel(font: .size(15), textColor: .c3)
    let defaultLabel = UILabel(text: "默认", font: .size(12), textColor: .c7c97b0, textAlignment: .center)
    let editBtn = UIButton(title: "编辑", font: .size(14), titleColor: .c9)
    
    var editClosure: ((HealthDataECGPatientModel) -> Void)?
    
    var model: HealthDataECGPatientModel! {
        didSet {
            nameLabel.text = model.realName
            sexLabel.text = model.sex == 1 ? "男" : "女"
            ageLabel.text = "\(getAge(model.birth) ?? 0)岁"
            let isDefault = model.isDefault == "Y"
            defaultLabel.isHidden = !isDefault
            
            let w = ageLabel.text!.zz_size(withLimitWidth: 200, fontSize: ageLabel.font.pointSize)
            ageLabel.snp.updateConstraints { (make) in
                make.width.equalTo(w)
            }
            
            defaultLabel.snp.updateConstraints { (make) in
                make.left.equalTo(ageLabel.snp.right).offset(isDefault ? 10 : 0)
                make.width.equalTo(isDefault ? 40 : 0)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
                make.right.lessThanOrEqualTo(editBtn.snp.left).offset(-15)
            }
        }
    }
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataMemberListCell {
    private func setUI() {
        editBtn.addTarget(self, action: #selector(toEditAction), for: .touchUpInside)
        
        defaultLabel.backgroundColor = .cf0fafc
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(sexLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(defaultLabel)
        contentView.addSubview(editBtn)
        
        contentView.addBottomLine()
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.width.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sexLabel.snp.right).offset(10)
            make.width.equalTo(35)
            make.centerY.equalToSuperview()
        }
        
        defaultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ageLabel.snp.right).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(editBtn.snp.left).offset(-10)
        }
        
        editBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(55)
        }
    }
}

// MARK: - Action
extension HealthDataMemberListCell {
    @objc private func toEditAction() {
        editClosure?(model)
    }
}

// MARK: - Helper
extension HealthDataMemberListCell {
    
}

// MARK: - Other
extension HealthDataMemberListCell {
    
}

// MARK: - Public
extension HealthDataMemberListCell {
    
}
