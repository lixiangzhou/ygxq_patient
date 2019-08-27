//
//  DoctorAssistModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct DoctorAssistModel: ModelProtocol, Equatable {
    var qiyuId: Int = 0
    var id: Int = 0
    var wechatQrCode: String = ""
    var title: String = ""
    var wechatId: String = ""
    var infobirdUser: String = ""
    var infobirdPasswd: String = ""
}
