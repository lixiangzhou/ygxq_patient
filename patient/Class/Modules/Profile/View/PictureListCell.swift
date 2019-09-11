//
//  PictureListCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PictureListCell: UICollectionViewCell {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let imgView = UIImageView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension PictureListCell {
    private func setUI() {
        imgView.backgroundColor = .cf0efef
        contentView.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Action
extension PictureListCell {
    
}

// MARK: - Helper
extension PictureListCell {
    
}

// MARK: - Other
extension PictureListCell {
    
}

// MARK: - Public
extension PictureListCell {
    
}
