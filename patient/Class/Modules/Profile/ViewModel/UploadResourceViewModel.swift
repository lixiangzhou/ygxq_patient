//
//  UploadResourceViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class UploadResourceViewModel: BaseViewModel {
    
    struct ImageItem: Equatable {
        var url: String?
        var image: UIImage?
    }
    
    let dataSourceProperty = MutableProperty([ImageItem(url: nil, image: UIImage())])

    func getHeaderSize(_ string: String) -> CGSize {
        let height = string.zz_size(withLimitWidth: UIScreen.zz_width - 30, fontSize: 16).height
        return CGSize(width: UIScreen.zz_width, height: height + 20)
    }
    
    var rowHeight: CGFloat {
        let count: CGFloat = 4
        return (UIScreen.zz_width - 30 - (count - 1) * 10) / count + 15
    }
    
    var rowCount: Int {
        return Int(ceil(Double(dataSourceProperty.value.count) / 4))
    }
    
    func itemsInRow(_ row: Int) -> [ImageItem] {
        let count = 4
        let startIdx = row * count
        
        let lastIdx = min((row + 1) * count, dataSourceProperty.value.count)
        let range = startIdx..<lastIdx
        return Array(dataSourceProperty.value[range])
    }
    
    func addItem(_ item: ImageItem) {
        addItems([item])
    }
    
    func addItems(_ items: [ImageItem]) {
        dataSourceProperty.value = dataSourceProperty.value + items
    }
    
    func addImages(_ images: [UIImage]) {
        var items = [ImageItem]()
        for img in images {
            items.append(ImageItem(url: nil, image: img))
        }
        addItems(items)
    }
    
    func delItem(_ item: ImageItem) {
        var items = dataSourceProperty.value
        items.removeAll { item == $0 }
        dataSourceProperty.value = items
    }
}

extension UploadResourceViewModel {
    func uploadImages() -> SignalProducer<[String]?, NoError> {
        var files = [FileData]()
        for (idx, item) in dataSourceProperty.value[1...].enumerated() {
            if let imgData = item.image?.pngData() {
                let name = Date().zz_string(withDateFormat: "yyyy_MM_dd_HH_mm_ss") + "\(idx)"
                files.append(FileData(data: imgData, name: name))
            }
        }
        
        return UploadApi.upload(datas: files).rac_responseModel([String].self)
    }
}
