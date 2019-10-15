//
//  PatientInfoModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

enum Sex: String, EnumProtocol, CustomStringConvertible {
    case unknown = "U"
    case male = "M"
    case female = "F"
    
    var description: String {
        switch self {
        case .unknown:
            return "未知"
        case .male:
            return "男"
        case .female:
            return "女"
        }
    }
    
    static func string(_ string: String?) -> Sex {
        if string == "男" {
            return .male
        } else if string == "女" {
            return .female
        } else {
            return .unknown
        }
    }
}

struct PatientInfoModel: ModelProtocol {
    // /auth/code/login 获取
    var serDiagnosisId: Int = 0
    var birth: TimeInterval?
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
    
    // /user/patient/information 接口新增
    var auid: Int = 0
    var nickName: String = ""
    var maritalMsg: String = ""
    var professionMsg: String = ""
    var fromWhere: String = ""
    var diseaseName: String = ""
    var projectName: String = ""
    var oldCtrSiteAssignmentId: Int = 0
    var sdistrictId: Int = 0
    var sdistrictName: String = ""
    var fdistrictId: Int = 0
    var fdistrictName: String = ""
    var issueName: String = ""
    var centresName: String = ""
    var rcId: Int = 0
    var serverId: Int = 0
    var diseaseMsg: String = ""
    var relativesM: String = ""
    var idCardNo: String = ""
}
