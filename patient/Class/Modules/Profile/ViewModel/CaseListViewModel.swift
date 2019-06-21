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
    let dataSourceProperty = MutableProperty<[CaseRecordModel]>([CaseRecordModel]())
    
    func getData(){
        HLRApi.caseRecordList(pid: patientId, type: 0).rac_responseModel([CaseRecordModel].self).startWithValues { [unowned self] (records) in
            if let records = records, !records.isEmpty {
                self.dataSourceProperty.value = records
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
