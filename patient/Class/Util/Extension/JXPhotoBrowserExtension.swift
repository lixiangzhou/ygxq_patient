//
//  JXPhotoBrowserExtension.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import JXPhotoBrowser

struct PhotoBrowser {
    static func show(numberOfItems: @escaping () -> Int,
                     placeholder: @escaping (Int) -> UIImage?,
                     autoloadURLString: @escaping (Int) -> String?,
                     showAt pageIndex: Int = 0) {
        
        let dataSource = JXNetworkingDataSource(photoLoader: JXKingfisherLoader(), numberOfItems: numberOfItems, placeholder: placeholder, autoloadURLString: autoloadURLString)
        
        JXPhotoBrowser(dataSource: dataSource, delegate: JXNumberPageControlDelegate())
            .show(pageIndex: pageIndex)
    }
}



