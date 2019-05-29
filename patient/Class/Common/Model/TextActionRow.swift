//
//  TextActionRow.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct TextActionRow {
    let title: String
    let action: (() -> Void)?
    let rightView: UIView?
    
    init(title: String, action: (() -> Void)? = nil, rightView: UIView? = nil) {
        self.title = title
        self.action = action
        self.rightView = rightView
    }
}
