//
//  CheckRecordModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct CheckRecordModel: ModelProtocol, Equatable {
    var id = 0
    var checklistName = ""
    var inspectHospital = ""
    var inspectTime: TimeInterval = 0
    var serCode = ""
    var puid = 0
    var type = 0
    var inspectName = ""
    var createTime: TimeInterval = 0
    
    var results: [Item] = []
    var imgs: [ImageModel] = []
    
    struct Item: ModelProtocol, Equatable {
        var rid = 0
        var inspectName = ""
        var inspectResult = ""
        var unit = ""
        var normalRange = ""
    }
}
