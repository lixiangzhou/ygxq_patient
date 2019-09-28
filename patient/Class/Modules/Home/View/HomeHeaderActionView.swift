//
//  HomeHeaderActionView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHeaderActionView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var item1Closure: (() -> Void)?
    var item2Closure: (() -> Void)?
    // MARK: - Private Property
    
    let item1View = ImageTitleView()
    let item2View = ImageTitleView()
}

// MARK: - UI
extension HomeHeaderActionView {
    private func setUI() {
        backgroundColor = .cf0efef
 
        let config = ImageTitleView.Config(imageInTop: true, imageSize: CGSize(width: 40, height: 40), verticalHeight1: 12, verticalHeight2: 5, titleLeft: 0, titleRight: 0, titleFont: .boldSize(19), titleColor: .c3)
        
        item1View.titleLabel.text = "复诊 / 购药"
        item1View.imgView.image = UIImage(named: "home_consult")
        item1View.backgroundColor = .cf
        item1View.config = config
        
        item2View.titleLabel.text = "随访计划"
        item2View.imgView.image = UIImage(named: "home_plan")
        item2View.backgroundColor = .cf
        item2View.config = config
        
        item1View.zz_setCorner(radius: 6, masksToBounds: true)
        item2View.zz_setCorner(radius: 6, masksToBounds: true)
        
        item1View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(item1Action)))
        item2View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(item2Action)))
        
        addSubview(item1View)
        addSubview(item2View)
        
        item1View.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        item2View.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(item1View.snp.right).offset(12)
            make.width.equalTo(item1View)
        }
    }
}

// MARK: - Action
extension HomeHeaderActionView {
    @objc private func item1Action() {
        item1Closure?()
    }
    
    @objc private func item2Action() {
        item2Closure?()
    }
}
