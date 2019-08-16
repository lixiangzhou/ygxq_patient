//
//  DoctorInfoModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct DoctorInfoModel: ModelProtocol {
    var report: Bool = false
    var birth: TimeInterval = 0
    var summary: String = ""
    var id: Int = 0
    var departmentId: Int = 0
    var certStatus: String = ""
    var hospitalName: String = ""
    var isArticlePush: String = ""
    var hospitalIds: String = ""
    var hospitalId: Int = 0
    var consult: Bool = false
    var idCardImg: String = ""
    var dpcNo: String = ""
    var dqcImg: String = ""
    var serPrice: Double = 0.0
    var listType: String = ""
    var operationNum: Int = 0
    var majorIn: String = ""
    var sex: Sex = .unknown
    var titleName: String = ""
    var lightHeartType: String = ""
    var dtcNo: String = ""
    var puid: Int = 0
    var realName: String = ""
    var inviteCode: String = ""
    var orderBy: String = ""
    var order: Bool = false
    var outpatientNum: Int = 0
    var departmentName: String = ""
    var pageSize: Int = 0
    var video: Bool = false
    var majorIns: String = ""
    var pageNum: Int = 0
    var dtcImg: String = ""
    var priDoctor: Bool = false
    var dpcImg: String = ""
    var districtName: String = ""
    var dqcNo: String = ""
    var searchKeyword: String = ""
    var isCtrResearcher: String = ""
    var titleId: Int = 0
    var modifyTime: TimeInterval = 0
    var modifier: Int = 0
    var imgUrl: String = ""
    var serManage: String = ""
    var auid: Int = 0
    var districtId: Int = 0
    var idCardNo: String = ""
    var isPersonalPush: String = ""
    var consultTel: Bool = false
    
    // serlong/getPrivateDoctorList 
    var videoPrice: Double = 0
    var bindingStatus: String = ""
    var phonePrice: Double = 0.0
    var reportPrice: Double = 0.0
    var countPers: Int = 0
    var serManages: String = ""
    var price: Double = 0.0
    var evaluate: Double = 0.0
    var duid: Int = 0
}
