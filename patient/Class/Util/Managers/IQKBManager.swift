//
//  IQKBManager.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

struct IQKBManager {
    static func setup() {
        IQKeyboardManager.shared.enable = true// 控制整个功能是否启用
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true// 控制点击背景是否收起键盘
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true // 控制键盘上的工具条文字颜色是否用户自定义
        IQKeyboardManager.shared.toolbarManageBehaviour = .bySubviews // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
        IQKeyboardManager.shared.enableAutoToolbar = true; // 控制是否显示键盘上的工具条
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true // 是否显示占位文字
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
    }
}
