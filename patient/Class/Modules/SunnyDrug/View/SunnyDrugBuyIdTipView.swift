//
//  SunnyDrugBuyIdTipView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugBuyIdTipView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugBuyIdTipView {
    private func setUI() {
        backgroundColor = .clear
        let backView = zz_add(subview: UIView())
        backView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
        let idView = zz_add(subview: UIImageView(image: UIImage(named: "sunny_drug_id_tip")))
        
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        idView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
