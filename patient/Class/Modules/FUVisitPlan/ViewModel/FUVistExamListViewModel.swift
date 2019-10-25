//
//  FUVistExamListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class FUVistExamListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[ExamModel]>([])
    
    let allFinishedProperty = MutableProperty<Bool>(false)
    
    var listCount = 0
    
    var type: ExamType!
    
    override init() {
        super.init()
        
        dataSourceProperty.signal.filter { (list) -> Bool in
            if list.isEmpty {
                return false
            } else {
                for item in list {
                    if item.isFinished == 0 {
                        return false
                    }
                }
                return true
            }
            }.observeValues { [weak self] (value) in
                guard let self = self else { return }
                CommonApi.updateTaskState(id: self.type.id).rac_response(String.self).startWithValues { (_) in }
                self.allFinishedProperty.value = true
        }
    }
    
    func getData() {
        guard let type = type else { return }
        
        switch type {
        case let .look(id: id):
            FLPApi.queryFlpExams(id: id).rac_responseModel([ExamModel].self).startWithValues { [weak self] (models) in
                self?.dataSourceProperty.value = models ?? []
            }
        case let .video(id: _, linkId: linkId):
            ServiceApi.queryExamResult(id: linkId).rac_responseModel(ExamResultModel.self).skipNil().filter { !$0.serExam.isEmpty }.startWithValues { [weak self] (model) in
                self?.getList(model)
            }
        case let .tel(id: _, linkId: linkId):
            TelApi.queryExamResult(tid: linkId).rac_responseModel(ExamResultModel.self).skipNil().filter { !$0.serExam.isEmpty }.startWithValues { [weak self] (model) in
                self?.getList(model)
            }
        case let .flp(id: _, linkId: linkId):
            FLPApi.queryFlpExams(id: linkId).rac_responseModel([ExamModel].self).startWithValues { [weak self] (models) in
                self?.dataSourceProperty.value = models ?? []
            }
        case let .sunnyDrug(id: _, linkId: linkId):
            SunnyDrugApi.queryExamResult(id: linkId).rac_responseModel(ExamResultModel.self).skipNil().filter { !$0.serExam.isEmpty }.startWithValues { [weak self] (model) in
                self?.getList(model)
            }
        case let .tellookLinkId(linkId: linkId):
            TelApi.queryExamResult(tid: linkId).rac_responseModel(ExamResultModel.self).skipNil().filter { !$0.serExam.isEmpty }.startWithValues { [weak self] (model) in
                self?.getList(model)
            }
        case let .videolookLinkId(linkId: linkId):
            ServiceApi.queryExamResult(id: linkId).rac_responseModel(ExamResultModel.self).skipNil().filter { !$0.serExam.isEmpty }.startWithValues { [weak self] (model) in
                self?.getList(model)
            }
        case let .druglookLinkId(linkId: linkId):
            SunnyDrugApi.queryExamResult(id: linkId).rac_responseModel(ExamResultModel.self).skipNil().filter { !$0.serExam.isEmpty }.startWithValues { [weak self] (model) in
                self?.getList(model)
            }
        }
    }
    
    func getList(_ model: ExamResultModel) {
        ExamApi.listSerExamById(ids: model.serExam.split(separator: ",").map { Int(String($0)) ?? 0 }).rac_responseModel([ExamModel].self).startWithValues { [weak self] (models) in
            if !model.serExamResult.isEmpty {
                if let self = self, let items = try? model.serExamResult.split(separator: ",").map { String($0) },
                    let results = try? items.map { (item) -> (String, String) in
                        let idx = item.firstIndex(of: ":")!
                        return (String(item[..<idx]), String(item[item.index(after: idx)...]))
                    } {

                    var ids = [Int: Int]()
                    for r in results {
                        ids[Int(r.0) ?? 0] = Int(r.1) ?? 0
                    }

                    let values = models ?? []
                    var newValues = [ExamModel]()
                    for v in values {
                        var newV = v
                        newV.isFinished = ids.keys.contains(v.id) ? 1 : 0
                        newV.resultId = ids[v.id] ?? 0
                        switch self.type! {
                        case .videolookLinkId, .druglookLinkId, .tellookLinkId:
                            if newV.isFinished == 1 {
                                newValues.append(newV)
                            }
                        default: 
                            newValues.append(newV)
                        }
                    }
                    self.dataSourceProperty.value = newValues
                }                
            } else {
                self?.dataSourceProperty.value = models ?? []
            }
        }
    }
    
    var webTitleString: String {
        switch type! {
        case .flp, .video, .sunnyDrug, .tel:
            return "填写随访问卷"
        default:
            return "查看问卷"
        }
    }
}

extension FUVistExamListViewModel {
    enum ExamType {
        case videolookLinkId(linkId: Int)
        case tellookLinkId(linkId: Int)
        case druglookLinkId(linkId: Int)
        case look(id: Int)
        case video(id: Int, linkId: Int)
        case tel(id: Int, linkId: Int)
        case flp(id: Int, linkId: Int)
        case sunnyDrug(id: Int, linkId: Int)
        
        var id: Int {
            switch self {
            case let .video(id: id, linkId: _):
                return id
            case let .tel(id: id, linkId: _):
                return id
            case let .flp(id: id, linkId: _):
                return id
            case let .sunnyDrug(id: id, linkId: _):
                return id
            default:
                return 0
            }
        }
    }
}
