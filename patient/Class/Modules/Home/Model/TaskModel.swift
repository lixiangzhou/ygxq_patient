//
//  TaskModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TaskModel: ModelProtocol {
    var id: Int = 0
    var clientType: String = ""
    var toUid: Int = 0
    var subType: String = ""
    var type: String = ""
    var title: String = ""
    var isLook: String = ""
    var createTime: TimeInterval = 0
    var gotoJson: String = ""
    var linkId: Int = 0
    var fromUid: Int = 0
    var content: String = ""
}

extension TaskModel {
    var taskActionTitle: String {
        switch actionType {
        case .finishQuestion:
            return "去填写"
        case .uploadResource:
            return "去完善"
        case .buyDrug:
            return "去购药"
        case .other: return ""
        }
    }
    
    var actionType: ActionType {
        switch subType {
        case "CMN_MSG_T_05_01", "CMN_MSG_T_05_02", "CMN_MSG_T_05_06":
            return .finishQuestion
        case "CMN_MSG_T_05_03", "CMN_MSG_T_05_04", "CMN_MSG_T_05_07":
            return .uploadResource
        case "CMN_MSG_T_05_05":
            return .buyDrug
        default: return .other
        }
    }
    
    var gotoJsonDuid: Int {
        if !gotoJson.isEmpty {
            let json = JSON(parseJSON: gotoJson)
            return json["duid"].intValue
        }
        return 0
    }
    
    var serType: String {
        switch subType {
        case "CMN_MSG_T_05_05":
            return "UTOPIA16"
        default:
            return ""
        }
    }
    
}

extension TaskModel {
    enum ActionType {
        case buyDrug
        case uploadResource
        case finishQuestion
        case other
    }
}
