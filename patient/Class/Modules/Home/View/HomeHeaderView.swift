//
//  HomeHeaderView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHeaderView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 90 + pagerHeight + actionsHeight + caseHeight + taskHeight + 45 + UIScreen.zz_statusBar_additionHeight))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let pagerView = FSPagerView()
    let pageControl = FSPageControl()
    let actionsView = HomeHeaderActionView()
    let caseView = HomeHeaderCaseView()
    let taskView = HomeHeaderTaskView()
    
    // MARK: - Private Property
    private let pagerHeight = (UIScreen.zz_width - 30) * 3.0 / 7.0
    private let actionsHeight: CGFloat = 85
    private let caseHeight: CGFloat = 110
    private let taskHeight: CGFloat = 150
}

// MARK: - UI
extension HomeHeaderView {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let bgView = zz_add(subview: UIImageView(image: UIImage(named: "home_top_bg")))
        
        pagerView.isInfinite = true
        pagerView.removesInfiniteLoopForSingleItem = true
        pagerView.automaticSlidingInterval = 2
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.description())
        pagerView.backgroundColor = .cf0efef
        addSubview(pagerView)
        
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.setImage(UIImage(named: "home_banner_selected"), for: .selected)
        pageControl.setImage(UIImage(named: "home_banner_normal"), for: .normal)
        pagerView.addSubview(pageControl)
        
        addSubview(actionsView)
        addSubview(caseView)
        addSubview(taskView)
        
        pagerView.zz_setCorner(radius: 6, masksToBounds: true)
        caseView.zz_setCorner(radius: 6, masksToBounds: true)
        taskView.zz_setCorner(radius: 6, masksToBounds: true)
        
        bgView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(180 + UIScreen.zz_statusBar_additionHeight)
        }
        
        pagerView.snp.makeConstraints { (make) in
            make.top.equalTo(90 + UIScreen.zz_statusBar_additionHeight)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(pagerHeight)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        actionsView.snp.makeConstraints { (make) in
            make.top.equalTo(pagerView.snp.bottom).offset(15)
            make.left.right.equalTo(pagerView)
            make.height.equalTo(actionsHeight)
        }
        
        caseView.snp.makeConstraints { (make) in
            make.top.equalTo(actionsView.snp.bottom).offset(15)
            make.left.right.equalTo(pagerView)
            make.height.equalTo(caseHeight)
        }
        
        taskView.snp.makeConstraints { (make) in
            make.top.equalTo(caseView.snp.bottom).offset(15)
            make.left.right.equalTo(pagerView)
        }
    }
}
