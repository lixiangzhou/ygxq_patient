//
//  FUVisitPlanCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class FUVisitPlanCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension FUVisitPlanCell {
    private func setUI() {
        
    }
}

// MARK: - Action
extension FUVisitPlanCell {
    
}

// MARK: - Helper
extension FUVisitPlanCell {
    
}

// MARK: - Other
extension FUVisitPlanCell {
    enum RowType: String {
        case flpExams = "查看随访问卷"
        case imgs = "查看图片资料"
        case getDocAdvice = "查看医生建议"
        case fail = "查看失败原因"
    }
}

// MARK: - Public
extension FUVisitPlanCell {
    
}
