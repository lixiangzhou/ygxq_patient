//
//  VideoConsultDocInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class VideoConsultDocInfoCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .boldSize(18), textColor: .c3, numOfLines: 1)
    let professionLabel = UILabel(font: .size(17), textColor: .c6)
    let hospitalLabel = UILabel(font: .size(17), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension VideoConsultDocInfoCell {
    private func setUI() {
        contentView.backgroundColor = .cf
        
        iconView.zz_setCorner(radius: 30, masksToBounds: true)
        iconView.zz_setBorder(color: .cdcdcdc, width: 0.5)
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(hospitalLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.right.lessThanOrEqualTo(-15)
            make.width.equalTo(0)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-16)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(-15)
        }
    }
}
