//
//  TextTableViewCellConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct TextTableViewCellConfig {
    /// 文本字体
    var font: UIFont
    /// 文本字体颜色
    var textColor: UIColor
    /// 文本距离左边的距离
    var leftPadding: CGFloat
    
    /// 右边的View
    var rightView: UIView?
    /// 右边的View大小，如果为nil，则是rightView的系统自动设置的大小
    var rightViewSize: CGSize?
    /// 右边的View距离右边的距离
    var rightPadding: CGFloat
    
    var hasBottomLine = true
    var bottomLineColor: UIColor?
    var bottomLineLeftPadding: CGFloat
    var bottomLineRightPadding: CGFloat
    var bottomLineHeight: CGFloat
    
    init(font: UIFont = UIFont.size(15),
        textColor: UIColor = UIColor.c3,
        leftPadding: CGFloat = 15,
        rightView: UIView = UIImageView(image: UIImage(named: "common_arrow_right")),
        rightViewSize: CGSize? = nil,
        rightPadding: CGFloat = 15,
        hasBottomLine: Bool = true,
        bottomLineColor: UIColor = UIColor.c3,
        bottomLineLeftPadding: CGFloat = 0,
        bottomLineRightPadding: CGFloat = 0,
        bottomLineHeight: CGFloat = 0.5) {
        self.font = font
        self.textColor = textColor
        self.leftPadding = leftPadding
        
        self.rightView = rightView
        self.rightViewSize = rightViewSize
        self.rightPadding = rightPadding
        
        self.hasBottomLine = hasBottomLine
        self.bottomLineLeftPadding = bottomLineLeftPadding
        self.bottomLineColor = bottomLineColor
        self.bottomLineRightPadding = bottomLineRightPadding
        self.bottomLineHeight = bottomLineHeight
    }
}

extension TextTableViewCellConfig: Equatable {
    static func == (lhs: TextTableViewCellConfig, rhs: TextTableViewCellConfig) -> Bool {
        return lhs.font.pointSize == rhs.font.pointSize &&
            lhs.textColor.rgbaValue == rhs.textColor.rgbaValue &&
            lhs.leftPadding == rhs.leftPadding &&
            lhs.rightViewSize == rhs.rightViewSize &&
            lhs.rightPadding == rhs.rightPadding &&
            lhs.rightView?.classForCoder == rhs.rightView?.classForCoder
    }
}
