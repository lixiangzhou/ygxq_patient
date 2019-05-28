//
//  TextActionRow.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct TextActionRow {
    let title: String
    let action: (() -> Void)?
    
    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
}
