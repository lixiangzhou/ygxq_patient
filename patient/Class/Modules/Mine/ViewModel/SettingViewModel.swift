//
//  SettingViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SettingViewModel: BaseViewModel {
    
    enum RowType: String {
        case addressMgr = "地址管理"
        case changeMobile = "更换手机号"
        case feedback = "意见反馈"
        case version = "当前版本"
    }
    
    struct RowModel {
        let type: RowType
        let config: TextTableViewCellConfig
    }
    
    var dataSource = [RowModel]()
    
    override init() {
        super.init()
        
        
        let versionLabel = UILabel(text: "\(UIApplication.shared.zz_appVersion)", font: .size(14), textColor: .c6)
        versionLabel.sizeToFit()
        
        dataSource += [
            RowModel(type: .addressMgr, config: TextTableViewCellConfig()),
            RowModel(type: .changeMobile, config: TextTableViewCellConfig()),
            RowModel(type: .feedback, config: TextTableViewCellConfig()),
            RowModel(type: .version, config: TextTableViewCellConfig(rightView: versionLabel, hasBottomLine: false)),
        ]
    }
}



