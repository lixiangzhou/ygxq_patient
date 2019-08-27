//
//  SunnyDrugOrderController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/13.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugOrderController: LLSegmentViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的续药"
        setUI()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
// MARK: - UI
extension SunnyDrugOrderController {
    override func setUI() {
        loadSegmentedConfig()
    }
    
    override func loadCtls() {
        let ingVC = SunnyDrugOrderListController()
        ingVC.title = "购药中"
        ingVC.viewModel.state = .ing
        
        let successVC = SunnyDrugOrderListController()
        successVC.title = "购药成功"
        successVC.viewModel.state = .success
        
        let failedVC = SunnyDrugOrderListController()
        failedVC.title = "购药失败"
        failedVC.viewModel.state = .failed
        
        reloadViewControllers(ctls:[ingVC, successVC, failedVC])
    }
}


// MARK: -
extension SunnyDrugOrderController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
