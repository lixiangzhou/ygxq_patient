//
//  HistoryProfileDataController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HistoryProfileDataController: LLSegmentViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "就诊记录"
        setUI()
    }
}

// MARK: - UI
extension HistoryProfileDataController {
    override func setUI() {
        loadSegmentedConfig()
    }
    
    override func loadCtls() {
        let caseListVC = CaseListController()
        caseListVC.title = "病历记录"
        
        let checkListVC = CheckListController()
        checkListVC.title = "检查记录"
        
        let questionListVC = ExamListController()
        questionListVC.title = "问卷记录"
        
        reloadViewControllers(ctls:[caseListVC, checkListVC, questionListVC])
    }
}

// MARK: - 
extension HistoryProfileDataController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
