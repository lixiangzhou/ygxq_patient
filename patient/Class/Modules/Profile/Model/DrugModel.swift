//
//  DrugModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct DrugModel: ModelProtocol {
    /// 药品名称
    var drugName = ""
    /// 包装规格
    var packSpec = ""
    /// 价格
    var unitPrice = 0.0
    /// 数量
    var buyNum = 0
    /// 用法
    var drugUsage = ""
    
    /// 医嘱
    var doctorAdvice = ""
}
