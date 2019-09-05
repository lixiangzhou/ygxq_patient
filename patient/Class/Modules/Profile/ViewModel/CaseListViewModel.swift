//
//  CaseListViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class CaseListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[Group]>([Group]())
    
    func getData(){
        HLRApi.caseRecordList(pid: patientId, type: 0).rac_responseModel([CaseRecordModel].self).startWithValues { [weak self] (records) in
            if let records = records, !records.isEmpty {
                
                var dict = [String: [CaseRecordModel]]()
                for record in records {
                    let key = record.createTime.toTime(format: "yyyy-MM-dd")
                    let value = dict[key]
                    if var value = value {
                        value.append(record)
                        dict[key] = value
                    } else {
                        dict[key] = [record]
                    }
                }
                let result = dict.sorted(by: { (d1, d2) -> Bool in
                    return d1.key > d2.key
                })
                
                var groups = [Group]()
                for item in result {
                    groups.append(Group(title: item.key, list: item.value))
                }
                
                self?.dataSourceProperty.value = groups
            }
        }
    }

    func getTypeString(_ model: CaseRecordModel) -> String {
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

extension CaseListViewModel {
    struct Group {
        var title: String
        var list: [CaseRecordModel]
    }
}
