//
//  CaseDetailViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class CaseDetailViewModel: BaseViewModel {
    let dataSourceProperty: MutableProperty<[Record]> = MutableProperty([])
    
    struct Record {
        var title = ""
        var subTitle = ""
        var items = [CaseRecordModel.OPAS]()
        var imgs = [ImageModel]()
        
        init(title: String, subTitle: String) {
            self.title = title
            self.subTitle = subTitle
        }
    }
    
    func getData(_ id: Int) {
        HLRApi.caseRecord(id: id).rac_responseModel(CaseRecordModel.self).startWithValues { [unowned self] (caseRecord) in
            if let caseRecord = caseRecord {
                var array = [Record]()
                if caseRecord.clinicHospital.count > 0 {
                    var r = Record(title: "就诊医院", subTitle: caseRecord.clinicHospital)
                    r.imgs = caseRecord.imgs
                    array.append(r)
                }
                
                if caseRecord.clinicTime > 0 {
                    array.append(Record(title: "入院时间", subTitle: caseRecord.clinicTime.toTime(format: "yyyy-MM-dd")))
                }
                
                if caseRecord.chiefComplaint.count > 0 {
                    array.append(Record(title: "主诉", subTitle: caseRecord.chiefComplaint))
                }
                
                if caseRecord.presentIllnessHis.count > 0 {
                    array.append(Record(title: "现病史", subTitle: caseRecord.presentIllnessHis))
                }
                
                if caseRecord.previousHis.count > 0 {
                    array.append(Record(title: "既往史", subTitle: caseRecord.previousHis))
                }
                
                if caseRecord.personalHis.count > 0 {
                    array.append(Record(title: "个人史", subTitle: caseRecord.personalHis))
                }
                
                if caseRecord.familyHis.count > 0 {
                    array.append(Record(title: "家族史", subTitle: caseRecord.familyHis))
                }
                
                if caseRecord.preDiagnosis.count > 0 {
                    array.append(Record(title: "初步诊断", subTitle: caseRecord.preDiagnosis))
                }
                
                for op in caseRecord.ops {
                    if op.opTime > 0 {
                        array.append(Record(title: "手术日期", subTitle: op.opTime.toTime(format: "yyyy-MM-dd")))
                    }
                    if op.opName.count > 0 {
                        array.append(Record(title: "手术名称", subTitle: op.opName))
                    }
                    
                    if op.opas.count > 0 {
                        var record = Record(title: "冠状动脉造影狭窄", subTitle: "")
                        record.items = op.opas
                        array.append(record)
                    }
                }
                
                if caseRecord.outTime > 0 {
                    array.append(Record(title: "出院日期", subTitle: caseRecord.outTime.toTime(format: "yyyy-MM-dd")))
                }
                
                if caseRecord.dischargeInstructions.count > 0 {
                    array.append(Record(title: "出院医嘱", subTitle: caseRecord.dischargeInstructions))
                }
                self.dataSourceProperty.value = array
            } else {
                self.dataSourceProperty.value = []
            }
        }
    }
}
