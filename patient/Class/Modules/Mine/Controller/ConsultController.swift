//
//  ConsultController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/13.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ConsultController: LLSegmentViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的咨询"
        setUI()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension ConsultController {
    override func setUI() {
        loadSegmentedConfig()
    }
    
    override func loadCtls() {
        let ingVC = ConsultListController()
        ingVC.title = "咨询进行中"
        ingVC.viewModel.state = .ing
        
        let edVC = ConsultListController()
        edVC.title = "咨询已完毕"
        edVC.viewModel.state = .finished
        
        reloadViewControllers(ctls:[ingVC, edVC])
    }
}


// MARK: -
extension ConsultController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
