//
//  MineViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class MineViewModel: BaseViewModel {
    
    enum RowType: String {
        case myDoc = "我的档案"
        case order = "我的订单"
        case setting = "设置"
    }
    
    struct RowModel {
        let type: RowType
        let img: String
        let config: TextTableViewCellConfig

        init(type: RowType, img: String, config: TextTableViewCellConfig) {
            self.type = type
            self.img = img
            self.config = config
        }
    }
    
    var dataSource = [[RowModel]]()
    
    override init() {
        super.init()
        
        dataSource.append([RowModel(type: .myDoc, img: "", config: commonCellConfig()),
                           RowModel(type: .order, img: "", config: lastCellConfig())])
        dataSource.append([RowModel(type: .setting, img: "", config: lastCellConfig())])
    }
}

extension MineViewModel {
    func getInfo() {
        PatientManager.shared.getPatientInfo()
    }
}
