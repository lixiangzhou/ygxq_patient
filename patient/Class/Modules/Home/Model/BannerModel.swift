//
//  BannerModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct BannerModel: ModelProtocol {
    var imgUrl: String = ""
    var content: String = ""
    var linkUrl: String = ""
    var id: Int = 0
    var isDisplay: String = ""
    var title: String = ""
    var clientType: String = ""
    var displayOrder: Int = 0
    var createTime: TimeInterval = 0
}
