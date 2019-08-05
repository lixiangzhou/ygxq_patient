//
//  PersonInfoEditViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PersonInfoEditViewModel: BaseViewModel {
    
    let sexDataSource = CommonPicker.DataSouce.one(["男", "女"])
    let heightDataSource: CommonPicker.DataSouce
    let weightDataSource: CommonPicker.DataSouce
    
    override init() {
        var heightDS = [CommonPicker.Group]()
        for idx in 50...250 {
            heightDS.append(CommonPicker.Group(title: idx.description, array: ["cm"]))
        }
        heightDataSource = CommonPicker.DataSouce.two(heightDS)
        
        
        var weightDS = [CommonPicker.Group]()
        for idx in 20...250 {
            weightDS.append(CommonPicker.Group(title: idx.description, array: ["kg"]))
        }
        weightDataSource = CommonPicker.DataSouce.two(weightDS)
        
        super.init()
    
        
        
        
    }

    var inputConfig: TextLeftRightFieldViewConfig {
        return TextLeftRightFieldViewConfig(leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightWidth: 200, rightLimit: 20)
    }
    
    var arrowConfig: LeftRightConfigViewConfig {
        return LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightPaddingLeft: 5)
    }
}
