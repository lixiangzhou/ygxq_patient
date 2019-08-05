//
//  BaseViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class BaseViewModel {
    
    func lastCellConfig() -> LeftRightConfigViewConfig {
        return LeftRightConfigViewConfig(leftView: UIImageView(), leftViewSize: CGSize(width: 20, height: 20), hasBottomLine: false)
    }
    
    func commonCellConfig() -> LeftRightConfigViewConfig {
        return LeftRightConfigViewConfig(leftView: UIImageView(), leftViewSize: CGSize(width: 20, height: 20), leftPaddingRight: 10, hasBottomLine: true)
    }
    
    deinit {
        print("DEINIT => \(self)")
    }
}
