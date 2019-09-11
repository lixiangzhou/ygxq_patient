//
//  AddressModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/2.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct AddressModel: ModelProtocol, Equatable {
    var id: Int = 0
    var uid: Int = 0
    var consignee: String = ""
    var mobile: String = ""
    var cmnDistrictId: Int = 0
    var district: String = ""
    var address: String = ""
    var isDefault: Bool = true
    var createTime: TimeInterval = 0
}


class AreaModel: ModelProtocol {
    var id = 0
    var name = ""
    var level = 0
    var fid = 0
    var orderNo = 0
    var fullName = ""
    
    var isSelect = false
    
    required init() {
    }
}
