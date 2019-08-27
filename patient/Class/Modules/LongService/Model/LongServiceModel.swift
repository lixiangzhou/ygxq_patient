//
//  LongServiceModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct LongServiceModel: ModelProtocol {
    var indate: Int = 0
    var serStatus: String = ""
    var serPrice: Double = 0.0
    var id: Int = 0
    var serFeature: String = ""
    var serSummary: String = ""
    var serName: String = ""
    var createTime: TimeInterval = 0
    
    var consultContent: String = ""
    var serCode: String = ""
    var serLongId: String = ""
    var orderStatus: String = ""
    var productName: String = ""
    var expirationTime: String = ""
    var consultStatus: String = ""
    var nmb: Int = 0
    var consultId: String = ""
}

extension LongServiceModel: ThreeColumnViewModelProtocol {
    var c1String: String {
        switch productName {
        case "UTOPIA16":
            return "阳光续药"
        case "UTOPIA15":
            return "视频咨询"
        default:
            return ""
        }
    }
    
    var c2String: String {
        return nmb.description + "次"
    }
    
    var c3String: String {
        return expirationTime
    }
}
