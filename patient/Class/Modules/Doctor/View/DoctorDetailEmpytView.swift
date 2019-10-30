//
//  DoctorDetailEmpytView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/30.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DoctorDetailEmpytView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let iconView = UIImageView(image: UIImage(named: "doctor_detail_empty"))
    let txtLabel = UILabel(text: "暂无内容", font: .size(18), textColor: .c3)
    // MARK: - Private Property
    
}

// MARK: - UI
extension DoctorDetailEmpytView {
    private func setUI() {
        backgroundColor = .cf
        let contentView = zz_add(subview: UIView())
        contentView.addSubview(iconView)
        contentView.addSubview(txtLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
