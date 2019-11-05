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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let idx = selectIndex {
            switch idx {
            case 0:
                vc1.viewModel.getData()
            case 1:
                vc2.viewModel.getData()
            case 2:
                vc3.viewModel.getData()
            default:
                break
            }
        }
    }
    
    // MARK: - Public Property
    var did = 0
    var selectIndex: Int?
    // MARK: - Private Property
    let vc1 = LongServiceController()
    let vc2 = LongServiceController()
    let vc3 = LongServiceController()
}

// MARK: - UI
extension LongServicesController {
    override func setUI() {
        loadSegmentedConfig()
        segmentCtlView.delegate = self
    }
    
    override func loadCtls() {
        vc1.title = "月"
        vc1.viewModel.indate = 1
        vc1.viewModel.did = did
        vc1.viewModel.index = 0
        
        vc2.title = "季"
        vc2.viewModel.indate = 3
        vc2.viewModel.did = did
        vc2.viewModel.index = 1
        
        vc3.title = "年"
        vc3.viewModel.indate = 12
        vc3.viewModel.did = did
        vc3.viewModel.index = 2
        
        reloadViewControllers(ctls:[vc1, vc2, vc3])
    }
}


extension LongServicesController: LLSegmentedControlDelegate {
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView) {
        selectIndex = destinationItemView.index
    }
    
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl,dragToSelected itemView: LLSegmentBaseItemView) {
        selectIndex = itemView.index
    }
}

// MARK: -
extension LongServicesController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
