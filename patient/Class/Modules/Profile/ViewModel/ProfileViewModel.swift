//
//  ProfileViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ProfileViewModel: BaseViewModel {
    enum RowType: String {
        case historyData = "历史数据"
        case drugRecord = "用药记录"
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
    
    var dataSource = [RowModel]()
    
    override init() {
        super.init()
        
        dataSource.append(RowModel(type: .historyData, img: "", config: commonCellConfig()))
        dataSource.append(RowModel(type: .drugRecord, img: "", config: lastCellConfig()))
    }
}
