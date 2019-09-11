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
        CommonApi.pushMsgs(uid: patientId).rac_responseModel([TaskModel].self).startWithValues { [weak self] (list) in
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
}
