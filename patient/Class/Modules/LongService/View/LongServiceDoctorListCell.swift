//
//  LongServiceDoctorListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LongServiceDoctorListCell: UITableViewCell {
    
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
    let nameLabel = UILabel(text: "", font: .size(18), textColor: .c3)
    let professionLabel = UILabel(text: "", font: .size(15), textColor: .c9)
    let hospitalLabel = UILabel(text: "", font: .size(15), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension LongServiceDoctorListCell {
    private func setUI() {
        iconView.zz_setCorner(radius: 30, masksToBounds: true)
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(hospitalLabel)
        
        let arrowView = contentView.zz_add(subview: UIImageView(image: UIImage(named: "common_right_arrow")))
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(iconView.snp.right).offset(14)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(-15)
            make.left.equalTo(nameLabel.snp.right).offset(20)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.left.equalTo(nameLabel)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
}
