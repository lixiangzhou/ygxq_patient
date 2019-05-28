//
//  MineViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class MineViewModel: BaseViewModel {
    
    enum RowType: String {
        case healthDoc = "健康档案"
        case consult = "我的咨询"
        case order = "我的订单"
        case service = "长期服务"
        case setting = "设置"
    }
    
    var dataSource = [RowType]()
    
    override init() {
        super.init()
        
        dataSource += [.healthDoc, .consult, .order, .service, .setting]
    }
}
