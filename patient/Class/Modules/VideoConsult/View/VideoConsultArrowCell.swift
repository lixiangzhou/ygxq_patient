//
//  VideoConsultArrowCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class VideoConsultArrowCell: UITableViewCell {
    
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
    
    // MARK: - Private Property
    let innerView = LeftRightConfigView()
}

// MARK: - UI
extension VideoConsultArrowCell {
    fileprivate func setUI() {
        contentView.backgroundColor = .cf0efef
        
        innerView.backgroundColor = .cf
        innerView.config = LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .boldSize(17), hasBottomLine: false)
        contentView.addSubview(innerView)
        
        innerView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

// MARK: - Action
extension VideoConsultArrowCell {
    
}

// MARK: - Helper
extension VideoConsultArrowCell {
    
}

// MARK: - Other
extension VideoConsultArrowCell {
    
}

// MARK: - Public
extension VideoConsultArrowCell {
    
}
