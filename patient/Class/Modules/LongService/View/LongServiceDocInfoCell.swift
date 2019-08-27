//
//  LongServiceDocInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/17.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LongServiceDocInfoCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(15), textColor: .c3, numOfLines: 1)
    let professionLabel = UILabel(font: .size(14), textColor: .c9)
    let hospitalLabel = UILabel(font: .size(14), textColor: .c6)
    // MARK: - Private Property
}

// MARK: - UI
extension LongServiceDocInfoCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let view = contentView.zz_add(subview: UIView())
        view.backgroundColor = .cf
        view.zz_setCorner(radius: 8, masksToBounds: true)
        
        iconView.zz_setCorner(radius: 22.5, masksToBounds: true)
        
        view.addSubview(iconView)
        view.addSubview(nameLabel)
        view.addSubview(professionLabel)
        view.addSubview(hospitalLabel)
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-12)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(45)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.right.lessThanOrEqualTo(-15)
            make.width.equalTo(0)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-13)
            make.left.equalTo(nameLabel)
        }
    }
}
