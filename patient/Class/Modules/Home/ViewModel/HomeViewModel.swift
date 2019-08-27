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
    
    func getBanners() {
        HomeApi.bannerList.rac_responseModel([BannerModel].self).skipNil().startWithValues { [weak self] (list) in
            self?.bannerListProperty.value = list
        }
    }
    
    func getTasks() {
        CommonApi.pushMsgs(uid: patientId).rac_responseModel([TaskModel].self).skipNil().startWithValues { [weak self] (list) in
            self?.taskListProperty.value = list
        }
    }
}
