//
//  MineViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class MineViewModel: BaseViewModel {
    
    enum RowType: String {
//        case myDoc = "我的档案"
        case consult = "我的咨询"
        case sunnyDrug = "我的续药"
        case longService = "长期服务"
        case order = "我的订单"
        case setting = "设置"
    }
    
    struct RowModel {
        let type: RowType
        let img: String
        let config: LeftRightConfigViewConfig

        init(type: RowType, img: String, config: LeftRightConfigViewConfig) {
            self.type = type
            self.img = img
            self.config = config
        }
    }
    
    var dataSource = [[RowModel]]()
    var unReadMsgCountProperty = MutableProperty<Int>(0)
    
    
    override init() {
        super.init()
        
        dataSource.append([RowModel(type: .consult, img: "mine_consult", config: commonCellConfig()),
                           RowModel(type: .sunnyDrug, img: "mine_sunnydrug", config: commonCellConfig()),
                           RowModel(type: .order, img: "mine_order", config: commonCellConfig()),
                           RowModel(type: .longService, img: "mine_longservice", config: lastCellConfig())])
        dataSource.append([RowModel(type: .setting, img: "mine_setting", config: lastCellConfig())])
    }
}

extension MineViewModel {
    func getInfo() {
        PatientManager.shared.getPatientInfo()
    }
    
    func getUnReadMsgCount() {
        CommonApi.unreadMsgCount(uid: patientId).rac_responseModel(Int.self).startWithValues { [weak self] (value) in
            self?.unReadMsgCountProperty.value = value ?? 0
        }
    }
}
