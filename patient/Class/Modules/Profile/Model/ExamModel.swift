//
//  ExamModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct ExamModel: ModelProtocol, Equatable {
    var id: Int = 0
    var resultId: Int = 0
    var quesCount: Int = 0
    var isLook: String = ""
    var examName: String = ""
    var isEffect: String = ""
    var createTime: TimeInterval = 0
    var type: String = ""
}
