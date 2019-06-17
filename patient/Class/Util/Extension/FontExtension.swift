//
//  FontExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

extension UIFont {
    /// 19 少数突出文字；18 主导航及多数按钮；17 少数重要文字；16 用在多数重要文字；15 用在多数重要文字；14 用在少数文字； 11 用在辅助行文字
    static func size(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    static func boldSize(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
}
