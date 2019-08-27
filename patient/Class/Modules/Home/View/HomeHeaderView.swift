//
//  HomeHeaderView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHeaderView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: pagerHeight + actionsHeight + caseHeight + taskHeight + 30))
        
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
    private let pagerHeight = UIScreen.zz_width * 4.0 / 7.0
    private let actionsHeight: CGFloat = 100
    private let caseHeight: CGFloat = 100
    private let taskHeight: CGFloat = 150
}

// MARK: - UI
extension HomeHeaderView {
    private func setUI() {
        backgroundColor = .cf0efef
        
        pagerView.isInfinite = true
        pagerView.removesInfiniteLoopForSingleItem = true
        pagerView.automaticSlidingInterval = 2
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.description())
        addSubview(pagerView)
        
        pageControl.setFillColor(.cf, for: .normal)
        pageControl.setFillColor(.c407cec, for: .selected)
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pagerView.addSubview(pageControl)
        
        addSubview(actionsView)
        addSubview(caseView)
        addSubview(taskView)
        
        pagerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(pagerHeight)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        actionsView.snp.makeConstraints { (make) in
            make.top.equalTo(pagerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(actionsHeight)
        }
        
        caseView.snp.makeConstraints { (make) in
            make.top.equalTo(actionsView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(caseHeight)
        }
        
        taskView.snp.makeConstraints { (make) in
            make.top.equalTo(caseView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
//            make.height.equalTo(150)
//            make.bottom.equalTo(-10)
        }
    }
}
