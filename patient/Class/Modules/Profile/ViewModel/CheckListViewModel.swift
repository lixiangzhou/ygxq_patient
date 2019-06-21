//
//  CheckListViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class CheckListViewModel: BaseViewModel {
    
    let dataSourceProperty = MutableProperty<[GroupModel<CheckRecordModel>]>([GroupModel<CheckRecordModel>]())
    
    func getData(){
        HLRApi.checkList(pid: patientId, type: 0).rac_responseModel([CheckRecordModel].self).startWithValues { [unowned self] (records) in
            if let records = records, !records.isEmpty {
                var datas = [String: [CheckRecordModel]]()
                for rd in records {
                    let time = rd.createTime.toTime(format: "yyyy-MM-dd")
                    var rds = datas[time]
                    if rds == nil {
                        rds = [CheckRecordModel]()
                    }
                    rds?.append(rd)
                    datas[time] = rds!
                }
                
                var groups = [GroupModel<CheckRecordModel>]()
                let keys = datas.keys.sorted(by: > )
                for k in keys {
                    groups.append(GroupModel(title: k, list: datas[k]!))
                }
                
                self.dataSourceProperty.value = groups
            }
        }
    }
    
    func getTypeString(_ model: CheckRecordModel) -> String {
        switch model.type {
        case 1:
            return "手动"
        case 2:
            return "咨询"
        case 3:
            return "随访"
        default:
            return ""
        }
    }
}
