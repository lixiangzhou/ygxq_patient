//
//  BindedDoctorsCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class BindedDoctorsCell: UITableViewCell {
    
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
    let iconView = UIImageView(image: UIImage(named: "doctor_avator"))
    let nameLabel = UILabel(font: .boldSize(15), textColor: .c3, numOfLines: 1)
    let professionLabel = UILabel(font: .size(13), textColor: .c9)
    let hospitalLabel = UILabel(font: .size(14), textColor: .c6)
    let servicesLabel = UILabel(font: .size(14), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension BindedDoctorsCell {
    private func setUI() {
        iconView.zz_setCorner(radius: 22.5, masksToBounds: true)
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(hospitalLabel)
        contentView.addSubview(servicesLabel)
        contentView.addBottomLine()
        
        let arrowView = contentView.zz_add(subview: UIImageView.defaultRightArrow())
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.width.height.equalTo(45)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(14)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(15)
            make.right.lessThanOrEqualTo(arrowView.snp.left).offset(-10)
            make.width.equalTo(0)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.left.equalTo(nameLabel)
        }
        
        servicesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hospitalLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
            make.right.equalTo(arrowView.snp.left).offset(-10)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        arrowView.sizeToFit()
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowView.zz_size)
        }
    }
}
