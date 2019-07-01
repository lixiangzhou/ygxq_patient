//
//  UploadResourceHeaderTipView.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class UploadResourceHeaderTipView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let textLabel = UILabel(font: .size(16), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension UploadResourceHeaderTipView {
    private func setUI() {
        backgroundColor = .cf
        
        addSubview(textLabel)
        addBottomLine()
        
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
}

// MARK: - Action
extension UploadResourceHeaderTipView {
    
}

// MARK: - Helper
extension UploadResourceHeaderTipView {
    
}

// MARK: - Other
extension UploadResourceHeaderTipView {
    
}

// MARK: - Public
extension UploadResourceHeaderTipView {
    
}
