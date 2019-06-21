//
//  GroupModels.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct GroupModel<Type> {
    var title: String
    var list: [Type]
}

extension GroupModel: Equatable where Type: Equatable {
}

