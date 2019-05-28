//
//  UILabel+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 17/3/12.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit


public extension UILabel {
    /// 快速创建Label
    ///
    /// - parameter text:      text
    /// - parameter font:  字体大小
    /// - parameter textColor: 字体颜色
    ///
    /// - returns: Label
    convenience init(text: String = "", font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor? = UIColor.darkGray, numOfLines: Int = 0, textAlignment: NSTextAlignment = .left) {
        self.init()
        
        self.font = font
        self.textColor = textColor
        self.text = text
        self.numberOfLines = numOfLines
        self.textAlignment = textAlignment
        
        sizeToFit()
    }
}
