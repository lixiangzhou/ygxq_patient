//
//  TaskTipListViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class TaskTipListViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[TaskModel]>([TaskModel]())
    var drugOrderProperty = MutableProperty<(TaskModel, OrderModel?)?>(nil)
    
    func getTasks() {
        CommonApi.pushMsgs(uid: patientId, type: "CMN_MSG_T_05").rac_responseModel([TaskModel].self).startWithValues { [weak self] (list) in
            self?.dataSourceProperty.value = list ?? []
        }
    }
    
    func queryBrugOrderInfoByTask(_ task: TaskModel) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        OrderApi.queryBrugOrderInfoByVideoId(vid: task.linkId).rac_responseModel(OrderModel.self).startWithValues { [weak self] (model) in
            self?.drugOrderProperty.value = (task, model)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    func toUploadResource(_ model: TaskModel, from controller: UIViewController) {
        let vc = UploadResourceController()
        vc.title = "完善资料"
        vc.tipString = model.content
        switch model.subType {
        case "CMN_MSG_T_05_03": // 视频
            vc.viewModel.type = .video(id: model.id, linkId: model.linkId)
        case "CMN_MSG_T_05_09": // 电话
            vc.viewModel.type = .tel(id: model.id, linkId: model.linkId)
        case "CMN_MSG_T_05_04": // 购药
            vc.viewModel.type = .sunnyDrug(id: model.id, linkId: model.linkId)
        default:
            break
        }
        controller.push(vc)
    }
    
    func toFinishExam(_ model: TaskModel, from controller: UIViewController) {
        let vc = FUVistExamListController()
        vc.title = "填写随访问卷"
        
        switch model.subType {
        case "CMN_MSG_T_05_01": // 视频
            ActionCollecter.sendData(lev: "34")
            vc.viewModel.type = .video(id: model.id, linkId: model.linkId)
        case "CMN_MSG_T_05_08": // 电话
            vc.viewModel.type = .tel(id: model.id, linkId: model.linkId)
        case "CMN_MSG_T_05_02": // 购药
            ActionCollecter.sendData(lev: "36")
            vc.viewModel.type = .sunnyDrug(id: model.id, linkId: model.linkId)
        case "CMN_MSG_T_05_06": // 随访
            ActionCollecter.sendData(lev: "35")
            vc.viewModel.type = .flp(id: model.id, linkId: model.linkId)
        default:
            break
        }
        controller.push(vc)
    }
}
