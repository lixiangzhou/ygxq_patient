//
//  CheckDetailViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class CheckDetailViewModel: BaseViewModel {
    let dataSourceProperty: MutableProperty<[Record]> = MutableProperty([])
    
    var checkRecord: CheckRecordModel?
    
    struct Record {
        var title = ""
        var subTitle = ""
        var results = [CheckRecordModel.Item]()
        
        init(title: String, subTitle: String) {
            self.title = title
            self.subTitle = subTitle
        }
    }
    
    func getData(_ id: Int) {
        HLRApi.checkRecord(id: id).rac_responseModel(CheckRecordModel.self).startWithValues { [unowned self] (checkRecord) in
            if let checkRecord = checkRecord {
                self.checkRecord = checkRecord
                
                var array = [Record]()
                array.append(Record(title: checkRecord.checklistName, subTitle: ""))
                array.append(Record(title: "检查地点", subTitle: checkRecord.inspectHospital))
                array.append(Record(title: "检查时间", subTitle: checkRecord.inspectTime.toTime(format: "yyyy-MM-dd")))
                var items = Record(title: "", subTitle: "")
                items.results = checkRecord.results
                array.append(items)
                self.dataSourceProperty.value = array
            } else {
                self.dataSourceProperty.value = []
            }
        }
    }
}
