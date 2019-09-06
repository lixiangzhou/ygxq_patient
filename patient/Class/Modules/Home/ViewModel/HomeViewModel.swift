//
//  HomeViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HomeViewModel: BaseViewModel {
    let bannerListProperty = MutableProperty<[BannerModel]>([BannerModel]())
    let taskListProperty = MutableProperty<[TaskModel]>([TaskModel]())
    var unReadMsgCountProperty = MutableProperty<Int>(0)
    var drugOrderProperty = MutableProperty<(TaskModel, OrderModel?)?>(nil)
    
    func getBanners() {
        HomeApi.bannerList.rac_responseModel([BannerModel].self).skipNil().startWithValues { [weak self] (list) in
            self?.bannerListProperty.value = list
        }
    }
    
    func getTasks() {
        CommonApi.pushMsgs(uid: patientId).rac_responseModel([TaskModel].self).startWithValues { [weak self] (list) in
            self?.taskListProperty.value = list ?? []
        }
    }
    
    func getUnReadMsgCount() {
        CommonApi.unreadMsgCount(uid: patientId).rac_responseModel(Int.self).skipNil().startWithValues { [weak self] (value) in
            self?.unReadMsgCountProperty.value = value
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
