//
//  SettingViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SettingViewModel: BaseViewModel {
    
    enum RowType: String {
        case addressMgr = "地址管理"
        case changePwd = "修改密码"
        case serviceProtocol = "阳光客户端服务协议"
        case version = "当前版本"
        case messageTip = "消息提醒"
    }
    
    struct RowModel {
        let type: RowType
        let config: LeftRightConfigViewConfig
    }
    
    var dataSource = [RowModel]()
    
    override init() {
        super.init()
        
        let versionLabel = UILabel(text: "\(UIApplication.shared.zz_appVersion)", font: .size(14), textColor: .c6)
        versionLabel.sizeToFit()
        
        let switchView = UISwitch()
        switchView.isOn = patientInfoProperty.value!.isPushMsg == "Y"
        
        dataSource += [
            RowModel(type: .changePwd, config: LeftRightConfigViewConfig()),
            RowModel(type: .messageTip, config: LeftRightConfigViewConfig(rightView: switchView)),
            RowModel(type: .addressMgr, config: LeftRightConfigViewConfig()),
            RowModel(type: .serviceProtocol, config: LeftRightConfigViewConfig()),
            RowModel(type: .version, config: LeftRightConfigViewConfig(rightView: versionLabel, hasBottomLine: false)),
        ]
        
        switchView.reactive.controlEvents(.valueChanged).observeValues { [weak self] (view) in
            if view.isOn == false {
                AlertView.show(title: nil, msg: "关闭消息提醒后，您将收不到医生给您推送的消息，确定关闭吗？", firstTitle: "取消", secondTitle: "确定", firstClosure: { (alert) in
                    view.setOn(true, animated: true)
                    alert.hide()
                }, secondClosure: { (alert) in
                    self?.updateMsgPush(view: view)
                    alert.hide()
                })
            } else {
                self?.updateMsgPush(view: view)
            }
        }
        
        
    }
    
    func updateMsgPush(view: UISwitch) {
        UserApi.msgPushSwitch(uid: patientId, push: view.isOn).rac_response(String.self).startWithValues { (result) in
            HUD.show(BoolString(result))
        }
    }
    
    func logout() {
        patientInfoProperty.value = nil
    }
}



