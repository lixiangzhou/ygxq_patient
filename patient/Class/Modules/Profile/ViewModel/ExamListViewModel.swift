//
//  ExamListViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class ExamListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[GroupModel<ExamModel>]>([GroupModel<ExamModel>]())
    
    func getData(){
        
        
        ExamApi.examList(pid: patientId).rac_responseModel([ExamModel].self).startWithValues { [unowned self] (exams) in
            if let exams = exams, !exams.isEmpty {
                var datas = [String: [ExamModel]]()
                for ex in exams {
                    let time = ex.createTime.toTime(format: "yyyy-MM-dd")
                    var exs = datas[time]
                    if exs == nil {
                        exs = [ExamModel]()
                    }
                    exs?.append(ex)
                    datas[time] = exs!
                }
                
                var groups = [GroupModel<ExamModel>]()
                let keys = datas.keys.sorted(by: > )
                for k in keys {
                    groups.append(GroupModel(title: k, list: datas[k]!))
                }
                
                self.dataSourceProperty.value = groups
            }
        }
    }
    
    func getTypeString(_ model: ExamModel) -> String {
        switch model.type {
        case "flp":
            return "随访"
        case "video":
            return "视频"
        case "drug":
            return "续药"
        default:
            return ""
        }
    }
}
