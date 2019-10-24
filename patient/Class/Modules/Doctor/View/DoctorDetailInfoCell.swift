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
    let nameLabel = UILabel(font: .boldSize(22), textColor: .cf, numOfLines: 1)
    let professionLabel = UILabel(font: .size(17), textColor: .cf)
    let hospitalLabel = UILabel(font: .size(17), textColor: .cf, numOfLines: 1)
    var serView: UICollectionView!
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension DoctorDetailInfoCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let topBgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 116 + UIScreen.zz_statusBar_additionHeight), image: UIImage.zz_gradientImage(fromColor: UIColor(stringHexValue: "#295DC3")!, toColor: UIColor(stringHexValue: "#74B0F6")!, size: CGSize(width: UIScreen.zz_width, height: 180), isHorizontal: false))
        contentView.addSubview(topBgView)
        
//        let bgView = contentView.zz_add(subview: UIView())
//        bgView.zz_setCorner(radius: 5, masksToBounds: true)
//        bgView.backgroundColor = .cf
        
        iconView.zz_setCorner(radius: 35, masksToBounds: true)
        iconView.zz_setBorder(color: .cf, width: 1.5)
        
        serView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        serView.register(cell: SerCell.self)
        serView.zz_setCorner(radius: 5, masksToBounds: true)
        serView.backgroundColor = .cf
        
        topBgView.addSubview(iconView)
        topBgView.addSubview(nameLabel)
        topBgView.addSubview(professionLabel)
        topBgView.addSubview(hospitalLabel)
        contentView.addSubview(serView)
        
        topBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(116)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.width.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView).offset(8)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(15)
            make.width.equalTo(0)
            make.right.lessThanOrEqualTo(-15)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView).offset(-8)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(-15)
        }
        
        serView.snp.makeConstraints { (make) in
            make.top.equalTo(topBgView.snp.bottom).offset(-30)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

// MARK: - Helper
extension DoctorDetailInfoCell {
    class SerCell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            innerView = ImageTitleView()
            innerView.config = ImageTitleView.Config(imageSize: CGSize(width: 62, height: 62), verticalHeight1: 15, verticalHeight2: 5, titleLeft: 0, titleRight: 0, titleFont: .boldSize(17), titleColor: .c3)
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
