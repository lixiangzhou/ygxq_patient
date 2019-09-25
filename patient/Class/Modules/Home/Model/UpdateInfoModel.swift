//
//  UpdateInfoModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/25.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

/* 版本信息 */
struct UpdateInfoModel: ModelProtocol {
    var appUrl: String = ""
    var appVersion: String = ""
    var osType: String = ""
    var id: Int = 0
    var appNotes: String = ""
    var packetSize: Int = 0
    var isForcedUpdate: String = ""
    var isPassed: String = ""
    var appType: String = ""
    var createTime: Int = 0
    var versionCode: Int = 0
}
