//
//  PictureSelectViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/30.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PictureSelectViewModel: BaseViewModel {
    let dataSourceProperty = MutableProperty<[PictureSelectView.ImageData]>([PictureSelectView.ImageData.empty])
    var maxCount = 30
    
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
    
    func add(images: [UIImage]) {
        var values = dataSourceProperty.value
        values.removeAll { (data) -> Bool in
            switch data {
            case .empty: return true
            case .data: return false
            }
        }
        if values.count < maxCount {
            for img in images {
                values.append(.data(image: img))
            }
        }
        if values.count < maxCount {
            values.append(.empty)
        }
        
        dataSourceProperty.value = values
    }
    
    func set(images: [UIImage]) {
        var values = [PictureSelectView.ImageData]()
        
        for img in images {
            values.append(.data(image: img))
        }
        
        if values.count < maxCount {
            values.append(.empty)
        }
        
        dataSourceProperty.value = values
        print(#function)
    }
}
