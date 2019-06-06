//
//  PatientInfoModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import HandyJSON

enum Sex: String, HandyJSONEnum {
    case unknown = "U"
    case male = "M"
    case female = "F"
}

struct PatientInfoModel: HandyJSON {
    var serDiagnosisId: Int = 0
    var birth: TimeInterval = 0
    var id: Int = 0
    var profession: String = ""
    var hospitalName: String = ""
    var isPushMsg: String = ""
    var lastLoginTime: TimeInterval = 0
    var hospitalId: String = ""
    var address: String = ""
    var inviteCodeUrl: String = ""
    var rcToken: String = ""
    var diseaseCode: String = ""
    var lastLoginIp: Int = 0
    var ctrSiteAssignmentId: Int = 0
    var salt: String = ""
    var sex: Sex = .unknown
    var edcGuid: String = ""
    var maritalStatus: String = ""
    var jiguangId: String = ""
    var userStatus: String = ""
    var height: Int = 0
    var detailedAddress: String = ""
    var regIp: Int = 0
    var realName: String = ""
    var mobile: String = ""
    var doctorName: String = ""
    var regOs: String = ""
    var createTime: TimeInterval = 0
    var regTime: TimeInterval = 0
    var userSessionPid: String = ""
    var uesrSessionId: String = ""
    var race: String = ""
    var familyHistory: String = ""
    var imgUrl: String = ""
    var sessionId: String = ""
    var weight: Double = 0
    var userName: String = ""
    var addressId: Int = 0
    var recruiterCode: String = ""
    var contactWay: String = ""
    var isPushPrt: String = ""
    var imei: String = ""
}
