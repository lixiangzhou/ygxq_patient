//
//  MsgModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/20.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct MsgModel: ModelProtocol {
    var id: Int = 0
    var clientType: String = ""
    var toUid: Int = 0
    var subType: String = ""
    var type: String = ""
    var title: String = ""
    var isLook: String = ""
    var createTime: Int = 0
    var gotoJson: String = ""
    var linkId: Int = 0
    var fromUid: Int = 0
    var content: String = ""
}
