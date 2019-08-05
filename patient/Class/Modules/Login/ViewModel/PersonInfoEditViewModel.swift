//
//  PersonInfoEditViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PersonInfoEditViewModel: BaseViewModel {

    var inputConfig: TextLeftRightFieldViewConfig {
        return TextLeftRightFieldViewConfig(leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightWidth: 200, rightLimit: 20)
    }
    
    var arrowConfig: LeftRightConfigViewConfig {
        return LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightPaddingLeft: 5)
    }
}
