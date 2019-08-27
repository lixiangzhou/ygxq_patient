//
//  VideoConsultDocInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//Copyright © 2019 sphr. All rights reserved.
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
    let nameLabel = UILabel(font: .size(17), textColor: .c3, numOfLines: 1)
    let professionLabel = UILabel(font: .size(15), textColor: .c9)
    let hospitalLabel = UILabel(font: .size(15), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension VideoConsultDocInfoCell {
    private func setUI() {
        iconView.zz_setCorner(radius: 25, masksToBounds: true)
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(hospitalLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(iconView.snp.right).offset(14)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(15)
            make.right.lessThanOrEqualTo(-15)
            make.width.equalTo(0)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.left.equalTo(nameLabel)
        }
    }
}
