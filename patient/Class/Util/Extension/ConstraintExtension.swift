//
//  ConstraintExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/10.
//  Copyright © 2019 sphr. All rights reserved.
//

import SnapKit

extension ConstraintMaker {
    func topOffsetFrom (_ controller: UIViewController, _ offset: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            top.equalTo(controller.view.safeAreaLayoutGuide).offset(offset)
        } else {
            top.equalTo(offset)
        }
    }
}
