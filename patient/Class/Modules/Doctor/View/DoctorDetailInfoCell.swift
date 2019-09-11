//
//  DoctorDetailInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DoctorDetailInfoCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(16), textColor: .c3)
    let professionLabel = UILabel(font: .size(14), textColor: .c9)
    let hospitalLabel = UILabel(font: .size(13), textColor: .c6)
    var serView: UICollectionView!
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension DoctorDetailInfoCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let bgView = contentView.zz_add(subview: UIView())
        bgView.zz_setCorner(radius: 5, masksToBounds: true)
        bgView.backgroundColor = .cf
        
        iconView.zz_setCorner(radius: 35, masksToBounds: true)
        iconView.zz_setBorder(color: .cf, width: 1.5)
        
        serView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        serView.register(cell: SerCell.self)
        serView.backgroundColor = .cf
        
        contentView.addSubview(iconView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(professionLabel)
        bgView.addSubview(hospitalLabel)
        bgView.addSubview(serView)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(bgView.snp.top)
            make.width.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(professionLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        serView.snp.makeConstraints { (make) in
            make.top.equalTo(hospitalLabel.snp.bottom)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(0)
            make.bottom.equalTo(-15)
        }
    }
}

// MARK: - Action
extension DoctorDetailInfoCell {
    
}

// MARK: - Helper
extension DoctorDetailInfoCell {
    class SerCell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            innerView = ImageTitleView()
            innerView.config = ImageTitleView.Config(imageSize: CGSize(width: 45, height: 45), verticalHeight1: 15, verticalHeight2: 10, titleLeft: 0, titleRight: 0, titleFont: .size(13), titleColor: .c6)
            contentView.addSubview(innerView)
            
            innerView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private var innerView: ImageTitleView!
        var imgView: UIImageView {
            return innerView.imgView
        }
        var titleLabel: UILabel {
            return innerView.titleLabel
        }
    }
}

// MARK: - Other
extension DoctorDetailInfoCell {
    
}

// MARK: - Public
extension DoctorDetailInfoCell {
    
}
