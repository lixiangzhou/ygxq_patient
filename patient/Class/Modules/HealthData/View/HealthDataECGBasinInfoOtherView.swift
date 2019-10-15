//
//  HealthDataECGBasinInfoOtherView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class HealthDataECGBasinInfoOtherView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let txtView = KMPlaceholderTextView()
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataECGBasinInfoOtherView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(15), leftTextColor: .c3)
        titleView.leftLabel.text = "其他"
        addSubview(titleView)
        
        txtView.placeholder = "请输入其他要描述的内容"
        txtView.placeholderFont = .size(14)
        txtView.placeholderColor = .c9
        txtView.font = .size(14)
        txtView.textColor = .c3
        addSubview(txtView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        txtView.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.top.equalTo(titleView.snp.bottom).offset(5)
            make.right.equalTo(-8)
            make.height.equalTo(90)
            make.bottom.equalTo(-10)
        }
    }
}
