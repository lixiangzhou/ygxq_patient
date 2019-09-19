//
//  ExamPicModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/19.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct ExamPicModel: ModelProtocol {
    var showTidyInfo = false
    var showExams = true
    var examsInfos = [ExamModel]()
}
