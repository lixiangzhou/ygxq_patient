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
        case modifyPwd = "修改密码"
        case messageNotify = "消息提醒"
        case addressMgr = "地址管理"
        case `protocol` = "阳光客户端服务协议"
        case version = "当前版本"
    }
    
    struct RowData {
        let type: RowType
        let config: TextTableViewCellConfig
    }
    
    var dataSource = [RowData]()
    
    private let switchView = UISwitch()
    
    override init() {
        super.init()
        
        
        switchView.addTarget(self, action: #selector(msgSwitchChangeAction), for: .valueChanged)
        
        let versionLabel = UILabel(text: "V\(UIApplication.shared.zz_appVersion)", font: .size(13), textColor: .blue)
        versionLabel.sizeToFit()
        
        dataSource += [
            RowData(type: .modifyPwd, config: TextTableViewCellConfig()),
            RowData(type: .messageNotify, config: TextTableViewCellConfig(rightView: switchView)),
            RowData(type: .addressMgr, config: TextTableViewCellConfig()),
            RowData(type: .protocol, config: TextTableViewCellConfig()),
            RowData(type: .version, config: TextTableViewCellConfig(rightView: versionLabel)),
        ]
    }
    
    @objc private func msgSwitchChangeAction(_ sw: UISwitch) {
    
    }
}

