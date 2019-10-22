//
//  TelConsultModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct TelConsultModel: ModelProtocol {
    var puid: Int = 0
    var duid: Int = 0
    var auid: Int = 0
    var realName: String = ""
    var telNum: String = ""
    var idCardNo: String = ""
    var appointTime: TimeInterval = 0
    var finishedTime: TimeInterval = 0
    var talkTime: TimeInterval = 0
    var consultStatus: String = ""
    var consultContent: String = ""
    var medias: [ImageModel] = [ImageModel]()
}
