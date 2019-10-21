//
//  DoctorDetailActionsCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DoctorDetailActionsCell: UITableViewCell {
    
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
    let titleLabel = UILabel(font: .boldSize(17), textColor: .c3)
    // MARK: - Private Property
    var serView: UICollectionView!
    
    let txtLabel = UILabel(font: .size(16), textColor: .c3)
}

// MARK: - UI
extension DoctorDetailActionsCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let bgView = contentView.zz_add(subview: UIView())
        bgView.zz_setCorner(radius: 5, masksToBounds: true)
        bgView.backgroundColor = .cf
        
        bgView.addSubview(titleLabel)
        
        serView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        serView.register(cell: SerCell.self)
        serView.backgroundColor = .cf
        bgView.addSubview(serView)
        
        bgView.addSubview(txtLabel)

        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-12)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
        
        serView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(35)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(serView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.bottom.equalTo(-15)
        }
    }
}

// MARK: - Helper
extension DoctorDetailActionsCell {
    class SerCell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            txtLabel.zz_setCorner(radius: 4, masksToBounds: true)
            txtLabel.zz_setBorder(color: .cdcdcdc, width: 0.5)
            contentView.addSubview(txtLabel)
            
            txtLabel.snp.makeConstraints { (make) in
                make.top.left.equalTo(1)
                make.bottom.right.equalTo(-1)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let txtLabel = UILabel(font: .size(15), textColor: .c9, textAlignment: .center)
    }
}
