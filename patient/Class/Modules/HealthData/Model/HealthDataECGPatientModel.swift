//
//  HealthDataECGPatientModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct HealthDataECGPatientModel: ModelProtocol {
    var puid: Int = 0
    var realName: String = ""
    var id: Int = 0
    var birth: TimeInterval?
    var isDelete: String = ""
    var isDefault: String = ""
    var sex: Int = 0
    var createTime: TimeInterval = 0
}

extension HealthDataECGPatientModel {
    var age: Int? {
        if let birth = birth {
            let birthDate = Date(timeIntervalSince1970: birth / 1000)
            let date = Date()
            
            var age = date.zz_year - birthDate.zz_year
            if (birthDate.zz_month > date.zz_month) || (birthDate.zz_month == date.zz_month && birthDate.zz_day > date.zz_day) {
                age -= 1
            }
            return age
        } else {
            return nil
        }
    }
}
