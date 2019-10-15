//
//  HealthDataECGDetailViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataECGDetailViewModel: BaseViewModel {
    let dataProperty = MutableProperty<HealthDataECGModel>(HealthDataECGModel())
}
