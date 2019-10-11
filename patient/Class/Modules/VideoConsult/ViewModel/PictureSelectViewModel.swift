//
//  PictureSelectViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/30.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PictureSelectViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[PictureSelectView.ImageData]>([PictureSelectView.ImageData.empty])
//    var maxCount = 30
    var emptyFirst = true
    
    var imgsCount: Int {
        var values = dataSourceProperty.value
        values.removeAll { (data) -> Bool in
            switch data {
            case .empty: return true
            case .data: return false
            }
        }
        return values.count
    }
    
    func set(images: [UIImage]) {
        var values = [PictureSelectView.ImageData]()
        
        for img in images {
            values.append(.data(image: img))
        }
        
        if emptyFirst {
            values.insert(.empty, at: 0)
        } else {
            values.append(.empty)
        }
        
        dataSourceProperty.value = values
    }
}
