//
//  LongServicesController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LongServicesController: LLSegmentViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "服务详情"
        setUI()
    }

    // MARK: - Public Property
    var did = 0
    // MARK: - Private Property
    
}

// MARK: - UI
extension LongServicesController {
    override func setUI() {
        loadSegmentedConfig()
    }
    
    override func loadCtls() {
        let vc1 = LongServiceController()
        vc1.title = "月"
        vc1.viewModel.indate = 1
        vc1.viewModel.did = did
        vc1.viewModel.index = 0
        
        let vc2 = LongServiceController()
        vc2.title = "季"
        vc2.viewModel.indate = 3
        vc2.viewModel.did = did
        vc2.viewModel.index = 1
        
        let vc3 = LongServiceController()
        vc3.title = "年"
        vc3.viewModel.indate = 12
        vc3.viewModel.did = did
        vc3.viewModel.index = 2
        
        reloadViewControllers(ctls:[vc1, vc2, vc3])
    }
}

// MARK: -
extension LongServicesController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
